extends Node

const VEC_MAPPED_TO_DIR := [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
const LOAD_DEPTH: int = 3
@onready var Loader: Node = get_node("../Loader")


var spawn_room_id: int = 9
var is_room_loaded: Array[Array] = []

func _ready() -> void:
	Loader.read()
	is_room_loaded.resize(Loader.space.size())
	for row in range(Loader.space[0].size()):
		is_room_loaded.append(Array([], TYPE_BOOL, "", null)) # an Array constructor that technically might allow for the 2D array to be typed
		is_room_loaded[row].fill(false)
	
	var spawn_room_index: Vector2i = Loader.locations_of(spawn_room_id)[0]
	var SpawnRoom: Room = load("res://scenes/rooms/room" + str(spawn_room_id) + ".tscn").instantiate()
	var player_scene: PackedScene = load("res://scenes/Player.tscn")
	var Player: CharacterBody2D;
	SpawnRoom.global_position = Vector2(0, 0)
	SpawnRoom.setup(spawn_room_id, spawn_room_index)

	get_tree().get_current_scene().add_child.call_deferred(SpawnRoom)
	Player = SpawnRoom.spawn_player(player_scene)
	get_tree().get_current_scene().add_child.call_deferred(Player)


func on_room_exited(Source: Room, dir: Room.ExitDir) -> void:
	recursive_room_load(Source, dir)
	#recursive_room_unload()


func recursive_room_load(Source: Room, source_exit_dir: Room.ExitDir, depth: int = LOAD_DEPTH) -> void:
	var next_room_index: Vector2i = Source.INDEX + VEC_MAPPED_TO_DIR[source_exit_dir]
	var next_room_id: Variant = Loader.at(next_room_index)  
	var EnteredRoom: Room
	
	if next_room_id and not is_room_loaded[next_room_index.y][next_room_index.x]:
		load_room(next_room_id, next_room_index, source_exit_dir, Source)
	if depth != 0:
		for exit: Room.ExitDir in Room.ExitDir:
			if EnteredRoom.exit_exists[exit] and exit != Room.opposite(source_exit_dir):
				recursive_room_load(EnteredRoom, exit, depth - 1)
	
func recursive_room_unload(Source: Room, enter_dir: Room.ExitDir, original_room_index: Vector2i, depth: int = LOAD_DEPTH):
	pass

func load_room(id: int, index: Vector2i, dir_to_snap_to: Room.ExitDir, RoomToSnapTo: Room):
	var RoomToLoad: Room = load("res://scenes/rooms/room" + str(id) + ".tscn").instantiate()
	
	get_tree().get_current_scene().add_child(RoomToLoad)
	RoomToSnapTo.connect_to_room(RoomToLoad, dir_to_snap_to)
	RoomToLoad.setup(id, index)
	is_room_loaded[index.y][index.x] = true
