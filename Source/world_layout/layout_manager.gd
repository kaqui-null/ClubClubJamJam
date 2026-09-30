extends Node

## Indexing this array with [enum Room.ExitDir] returns the direction the enum references.[br]
## Example: [code]VEC_MAPPED_TO_DIR[ExitDir.RIGHT] = Vector2(1, 0)[/code]
const VEC_MAPPED_TO_DIR := [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
## How many "layers" of rooms to load in front of the loaded room. [br]
## A 0 means just room you entered gets loaded. (somewhere between 3 and 5 works best i guess)
const LOAD_DEPTH: int = 3
## How for from the room you just left should the manager start unloading. [br]
## A 0 means everything behind you except the room you just left is unloaded. [br][br]
## [u]Leave this at -1 (to disable it), we're talking less than a MB per room in savings here. [/u]
const UNLOAD_DEPTH: int = 0

## Set this to the id of the room you want to load first.
@export var spawn_room_id: int

var load_allowed: bool = true # no, disabling this does not disable loading
var loaded_rooms: Array[Array] = []

@onready var Loader: Node = get_node("../Loader")

func _ready() -> void:
	Loader.read()
	loaded_rooms.resize(Loader.space.size())
	for row in range(Loader.space.size()):
		loaded_rooms[row] = Array([], TYPE_OBJECT, "Node2D", Room) # an Array constructor that technically might allow for the 2D array to be typed
		loaded_rooms[row].resize(Loader.space[0].size())
	
	var spawn_room_index: Vector2i = Loader.locations_of(spawn_room_id)[0]
	var SpawnRoom: Room = load("res://Source/scenes/rooms/room" + str(spawn_room_id) + ".tscn").instantiate()
	var player_scene: PackedScene = load("res://Source/scenes/Player.tscn")
	var Player: CharacterBody2D;
	
	SpawnRoom.global_position = Vector2(0, 0)
	SpawnRoom.setup(spawn_room_id, spawn_room_index)
	loaded_rooms[spawn_room_index.y][spawn_room_index.x] = SpawnRoom
	Player = SpawnRoom.spawn_player(player_scene)
	once_after_ready.call_deferred(SpawnRoom, Player)

## Exists because [method Node.add_child] can't be run in [method Node._ready].
func once_after_ready(SpawnRoom: Room, Player: CharacterBody2D) -> void:
	var ExitDetection: Area2D;
	
	get_tree().get_current_scene().add_child(SpawnRoom)
	get_tree().get_current_scene().add_child(Player)
	ExitDetection = Player.get_node("Area2D")
	ExitDetection.body_shape_entered.connect(on_room_exited.unbind(2)) # unbind removes last two signal args (on_room_exited does not need them)
	ExitDetection.body_shape_exited.connect(on_room_entered.unbind(4))

func recursive_room_load(Source: Room, source_exit_dir: Room.ExitDir, depth: int = LOAD_DEPTH) -> void:
	var index: Vector2i = Source.INDEX + VEC_MAPPED_TO_DIR[source_exit_dir]
	var id: Variant = Loader.at(index)  
	var EnteredRoom: Room;

	if id and not loaded_rooms[index.y][index.x]:
		load_room(id, index, source_exit_dir, Source)
	if depth != 0:
		EnteredRoom = loaded_rooms[index.y][index.x]
		for exit: Room.ExitDir in Room.ExitDir.values():
			if EnteredRoom.exit_exists[exit] and exit != Room.opposite(source_exit_dir):
				recursive_room_load(EnteredRoom, exit, depth - 1)

func recursive_room_unload(Source: Room, source_exit_dir: Room.ExitDir, depth: int = UNLOAD_DEPTH, is_origin: bool = false) -> void:
	var index: Vector2i = Source.INDEX if is_origin else Source.INDEX + VEC_MAPPED_TO_DIR[source_exit_dir]
	var id: Variant = Loader.at(index)
	var EnteredRoom: Room = loaded_rooms[index.y][index.x]
	
	if id and EnteredRoom:
		for exit: Room.ExitDir in Room.ExitDir.values():
			if EnteredRoom.exit_exists[exit] and exit != Room.opposite(source_exit_dir) and not is_origin:
				recursive_room_unload(EnteredRoom, exit, depth - 1)
			elif EnteredRoom.exit_exists[exit] and exit != source_exit_dir and is_origin:
				recursive_room_unload(EnteredRoom, exit, depth - 1)
		if depth < 0:
			EnteredRoom.queue_free()
			loaded_rooms[index.y][index.x] = null

func load_room(id: int, index: Vector2i, dir_to_snap_to: Room.ExitDir, RoomToSnapTo: Room) -> void:
	var scene_to_load: PackedScene = load("res://Source/scenes/rooms/room" + str(id) + ".tscn")
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

	if load_allowed == true:
		load_allowed = false
		recursive_room_load(ExitedRoom, exit_direction)
		if UNLOAD_DEPTH != -1:
			recursive_room_unload(ExitedRoom, exit_direction, UNLOAD_DEPTH, true)

## This system prevents properly triggering [method on_room_exited] from the opposite exit if entering a room.
func on_room_entered() -> void:
	load_allowed = true
