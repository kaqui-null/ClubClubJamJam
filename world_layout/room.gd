class_name Room
extends Node2D

var ID: int;
var INDEX: Vector2i;
var exits: Array[Vector2i];
var exit_exists: Array[bool]; 
enum ExitDir {UP, RIGHT, DOWN, LEFT} # clockwise

signal room_exited(_Room: Room, dir: ExitDir)


func _ready() -> void:
	exits.resize(4)
	exit_exists.resize(4)
	update_exits()
	$Exits.visible = false

func connect_to_room(target: Room, opposing_dir: ExitDir) -> void:
	var vec_mapped_to_dir := [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
	var tilesize: int = $Exits.tile_set.tile_size.x 
	var dir: ExitDir = opposite(opposing_dir)
	var placement_location: Vector2 = target.global_position
	
	assert(target.exit_exists[opposing_dir], 
	"Attempted to place room at nonexistent exit.")
	assert(exit_exists[dir],
	"No compatible exit to connect to the room.")
	placement_location += tilesize * (Vector2(target.exits[opposing_dir])
						+ vec_mapped_to_dir[opposing_dir] 
						- Vector2(exits[dir]))
	global_position = placement_location

func update_exits() -> void:
	var cells: Array[Vector2i];

	for dir in ExitDir.values():
		cells = $Exits.get_used_cells_by_id(-1, Vector2i(int(dir), 0))
		if cells.size() == 1:
			exit_exists[dir] = true
			# i cannot just assign it without using Vector2i() constructor, idk why
			exits[dir] = Vector2i(cells[0])
		elif cells.size() == 0:
			exit_exists[dir] = false
		else:
			push_error("Two or more exits of the " + dir_name(dir) + " direction, only one instance is allowed.")
			return
	print_exits()

func print_exits() -> void:
	print(" ")
	for dir in ExitDir.values():
		if exit_exists[dir]:
			print(dir_name(dir) + " = " + str(exits[dir]))
		else:
			print(dir_name(dir) + " = " + "Absent")
	print(" ")

static func dir_name(dir: ExitDir) -> String:
	return ExitDir.keys()[dir]

static func opposite(dir: ExitDir) -> ExitDir:
	if dir > 1:
		dir -= 2
	else:
		dir += 2
	return dir
