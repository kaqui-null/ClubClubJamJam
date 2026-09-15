extends Node

const VEC_MAPPED_TO_DIR := [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
const LOAD_DEPTH: int = 3
@onready var loader: Node = get_node("../Loader")

var last_room_exited: int; #ID
var is_room_loaded: Array[Array] = []

func _ready() -> void:
	loader.read()
	is_room_loaded.resize(loader.space.size())
	for row in range(loader.space[0].size()):
		is_room_loaded.append(Array([], TYPE_BOOL, "", null)) # an Array constructor that technically might allow for the 2D array to be typed
		is_room_loaded[row].fill(false)
		
	# TODO : load first room

func on_room_exited(Source: Room, dir: Room.ExitDir) -> void:
	recursive_room_load(Source, dir)
	recursive_room_unload()
	#recursive_room_load(next_room, 

func recursive_room_load(Source: Room, source_exit_dir: Room.ExitDir, depth: int = LOAD_DEPTH) -> void:
	var next_room_index: Vector2i = Source.INDEX + VEC_MAPPED_TO_DIR[source_exit_dir]
	var next_room_id: Variant = loader.at(next_room_index)  
	var EnteredRoom: Room
	
	if next_room_id and not is_room_loaded[next_room_index.y][next_room_index.x]:
		load_room(next_room_id, next_room_index, source_exit_dir, Source)
	if depth != 0:
		for exit: Room.ExitDir in Room.ExitDir:
			if EnteredRoom.exit_exists[exit] and exit != Room.opposite(source_exit_dir):
				recursive_room_load(EnteredRoom, exit, depth - 1)
	
func recursive_room_unload(From: Room, enter_dir: Room.ExitDir, depth: int = LOAD_DEPTH - 1):
	pass

func load_room(id: int, index: Vector2i, dir_to_snap_to: Room.ExitDir, RoomToSnapTo: Room):
	var RoomToLoad = load("res://scenes/rooms/room" + str(id) + ".tscn").instantiate()
	get_tree().get_current_scene().add_child(RoomToLoad)
	RoomToSnapTo.connect_to_room(RoomToLoad, dir_to_snap_to)
	RoomToLoad.ID = id
	RoomToLoad.INDEX = index
	is_room_loaded[index.y][index.x] = true
