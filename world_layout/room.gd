class_name Room
extends Node2D

var ID: int;
var INDEX: Vector2i;
var exits: Array[Vector2i];
var exit_exists: Array[bool]; 
var has_spawnpoint: bool;
var spawn_location: Vector2i;
const DIR_TO_VEC := [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
enum ExitDir {UP, RIGHT, DOWN, LEFT} # clockwise

signal room_exited(_Room: Room, dir: ExitDir)


func setup(id: int, index: Vector2i) -> void:
	ID = id
	INDEX = index
	$Exits.visible = false
	exits.resize(4)
	exit_exists.resize(4)
	update_exits()
	setup_spawn()

func spawn_player(player_scene: PackedScene) -> CharacterBody2D:
	var Player: CharacterBody2D = player_scene.instantiate()
	var tilesize: int = $Exits.tile_set.tile_size.x 
	# CAUTION: These dimensions are assumptions and should later on be retrieved from the Sprite node or animated sprite of Player directly!
	var height: int = 35
	var width: int = 24
	#sprite is assumed to be centered
	Player.global_position = spawn_location * tilesize
	Player.global_position.x += (tilesize - width) * 0.5
	Player.global_position.y += tilesize - height
	
	return Player

func connect_to_room(target: Room, opposing_dir: ExitDir) -> void:
	var tilesize: int = $Exits.tile_set.tile_size.x 
	var dir: ExitDir = opposite(opposing_dir)
	var placement_location: Vector2 = target.global_position
	
	assert(target.exit_exists[opposing_dir], 
	"Attempted to place room at nonexistent exit.")
	assert(exit_exists[dir],
	"No compatible exit to connect to the room.")
	placement_location += tilesize * (Vector2(target.exits[opposing_dir])
						+ DIR_TO_VEC[opposing_dir] 
						- Vector2(exits[dir]))
	global_position = placement_location

func update_exits() -> void:
	var atlas_index := Vector2i();
	var cells: Array[Vector2i];

	for dir: int in ExitDir.values():
		atlas_index.x = dir
		cells = $Exits.get_used_cells_by_id(-1, atlas_index)
		if cells.size() == 1:
			exit_exists[dir] = true
			# i cannot just assign it without using Vector2i() constructor, idk why
			exits[dir] = Vector2i(cells[0])
		elif cells.size() == 0:
			exit_exists[dir] = false
		else:
			push_error("At room" + str(ID) + " -> Each direction can only have one exit.")
			return
	print_exits()

func setup_spawn() -> void:
	var spawn_atlas_index := Vector2i(4, 0)
	var spawn_cells: Array[Vector2i] = $Exits.get_used_cells_by_id(-1, spawn_atlas_index)
	print(spawn_cells)
	if spawn_cells.size() == 0:
		has_spawnpoint = false
	elif spawn_cells.size() == 1:
		has_spawnpoint = true
		spawn_location = spawn_cells[0]
	else:
		push_error("At room" + str(ID) + " -> More than one spawn per room is not allowed.")

func print_exits() -> void:
	print(" ")
	for dir: int in ExitDir.values():
		if exit_exists[dir]:
			print(dir_name(dir) + " = " + str(exits[dir]))
		else:
			print(dir_name(dir) + " = " + "Absent")
	print(" ")

static func dir_name(dir: ExitDir) -> String:
	return ExitDir.keys()[dir]

static func opposite(dir: ExitDir) -> ExitDir:
	if dir > 1:
		dir -= 2 as ExitDir
	else:
		dir += 2 as ExitDir
	return dir
