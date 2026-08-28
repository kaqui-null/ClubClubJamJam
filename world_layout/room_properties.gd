@tool
class_name RoomProperties
extends Resource

var Room: Node2D;
var exits: Array[Vector2i];
var exit_exists: Array[bool]; 
enum ExitDir {UP, RIGHT, DOWN, LEFT} # clockwise

func _init() -> void:
	exits.resize(4)
	exit_exists.resize(4)

func update_exits() -> void:
	var cells: Array[Vector2i];
	var ExitMap: TileMapLayer = Room.get_node("Exits")

	for dir in ExitDir.values():
		cells = ExitMap.get_used_cells_by_id(-1, Vector2i(int(dir), 0))
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

func dir_name(dir: ExitDir) -> String:
	return ExitDir.keys()[dir]

func opposite(dir: ExitDir) -> ExitDir:
	if dir > 1:
		dir -= 2
	else:
		dir += 2
	return dir
