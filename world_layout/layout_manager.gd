extends Node

const VEC_MAPPED_TO_DIR := [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
const LOAD_DEPTH: int = 0
@onready var Loader: Node = get_node("../Loader")


var spawn_room_id: int = 9
var loaded_rooms: Array[Array] = []

func _ready() -> void:
	Loader.read()
	loaded_rooms.resize(Loader.space.size())
	for row in range(Loader.space.size()):
		loaded_rooms[row] = Array([], TYPE_OBJECT, "Node2D", Room) # an Array constructor that technically might allow for the 2D array to be typed
		loaded_rooms[row].resize(Loader.space[0].size())
	
	var spawn_room_index: Vector2i = Loader.locations_of(spawn_room_id)[0]
	var SpawnRoom: Room = load("res://scenes/rooms/room" + str(spawn_room_id) + ".tscn").instantiate()
	var player_scene: PackedScene = load("res://scenes/Player.tscn")
	var Player: CharacterBody2D;
	
	SpawnRoom.global_position = Vector2(0, 0)
	SpawnRoom.setup(spawn_room_id, spawn_room_index)
	loaded_rooms[spawn_room_index.y][spawn_room_index.x] = SpawnRoom
	Player = SpawnRoom.spawn_player(player_scene)
	once_after_ready.call_deferred(SpawnRoom, Player)

func once_after_ready(SpawnRoom: Room, Player: CharacterBody2D) -> void:
	var ExitDetection: Area2D;
	
	get_tree().get_current_scene().add_child(SpawnRoom)
	get_tree().get_current_scene().add_child(Player)
	ExitDetection = Player.get_node("Area2D")
	ExitDetection.body_shape_entered.connect(on_room_exited.unbind(2)) # unbind removes last two signal args (on_room_exited does not need them)

func recursive_room_load(Source: Room, source_exit_dir: Room.ExitDir, depth: int = LOAD_DEPTH) -> void:
	var EnteredRoom: Room;
	var entered_room_index: Vector2i = Source.INDEX + VEC_MAPPED_TO_DIR[source_exit_dir]
	var entered_room_id: Variant = Loader.at(entered_room_index)  

	if entered_room_id and not loaded_rooms[entered_room_index.y][entered_room_index.x]:
		load_room(entered_room_id, entered_room_index, source_exit_dir, Source)
	if depth != 0:
		EnteredRoom = loaded_rooms[entered_room_index.y][entered_room_index.x]
		for exit: Room.ExitDir in Room.ExitDir.values():
			if EnteredRoom.exit_exists[exit] and exit != Room.opposite(source_exit_dir):
				recursive_room_load(EnteredRoom, exit, depth - 1)
	
func recursive_room_unload(Source: Room, enter_dir: Room.ExitDir, original_room_index: Vector2i, depth: int = LOAD_DEPTH):
	pass

func load_room(id: int, index: Vector2i, dir_to_snap_to: Room.ExitDir, RoomToSnapTo: Room) -> void:
	var scene_to_load: PackedScene = load("res://scenes/rooms/room" + str(id) + ".tscn")
	var RoomToLoad: Room; 
	
	assert(scene_to_load, "Room" + str(id) + " failed to load. Likely because it does not exist or is not present in the correct folder.")
	RoomToLoad = scene_to_load.instantiate()
	RoomToSnapTo.add_sibling(RoomToLoad)
	RoomToLoad.setup(id, index)
	RoomToLoad.connect_to_room(RoomToSnapTo, dir_to_snap_to)
	loaded_rooms[index.y][index.x] = RoomToLoad

## Reacts if [signal Area2D.body_shape_entered] of the Player's Area2D enters one of the Exit tiles. [br][br]
## With [param body] (renamed to [param Exits]) force-typed to [TileMapLayer], 
## the modified method ensures that an error is raised if anything else can be detected at the 6th collision layer.
func on_room_exited(tile_rid: RID, Exits: TileMapLayer) -> void:
	var ExitedRoom: Room = Exits.get_parent()    
	var tile_index: Vector2i = Exits.get_coords_for_body_rid(tile_rid)
	var exit_direction := Exits.get_cell_atlas_coords(tile_index).x #as Room.ExitDir

	recursive_room_load(ExitedRoom, exit_direction)
