class_name Room
extends Node2D
## Attached to every room, contains their behaviour and individual properties.

signal room_exited(_Room: Room, dir: ExitDir)

enum ExitDir {UP, RIGHT, DOWN, LEFT} # clockwise

const DIR_TO_VEC := [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]

# Don't touch any of these, they are automatically set when the room is loaded.
var ID: int;
var INDEX: Vector2i;
var exits: Array[Vector2i];
var exit_exists: Array[bool];  # since there is no value for Vector2i that could be considered invalid
var has_spawnpoint: bool;
var spawn_location: Vector2i;

## Returns the direction's name as a string. [br]Example: [enum ExitDir].UP -> "UP"
static func dir_name(dir: ExitDir) -> String:
	return ExitDir.keys()[dir]

## Returns the direction's opposing direction. [br]Example: [enum ExitDir].UP -> [enum ExitDir].DOWN
static func opposite(dir: ExitDir) -> ExitDir:
	if dir > 1:
		dir = (dir - 2) as ExitDir
	else:
		dir = (dir + 2) as ExitDir
	return dir

## Detects and sets all the properties. [br]Gets called from [method "world_layout/layout_manager.gd".load_room].
func setup(id: int, index: Vector2i) -> void:
	ID = id
	INDEX = index
	$Exits.visible = true
	$Exits.physics_quadrant_size = 1 # CAUTION: This is temporary cuz I forgot to set it before and dont want to set it individualy for each room yet
	exits.resize(4)
	exit_exists.resize(4)
	update_exits()
	setup_spawn()

## Instantiates and places the player at the spawn_location.
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

## Moves [code]self[/code] such that it snaps to the opposing exit of the [param target].
func connect_to_room(target: Room, opposing_dir: ExitDir) -> void:
	var tilesize: int = $Exits.tile_set.tile_size.x 
	var dir: ExitDir = opposite(opposing_dir)
	var placement_location := Vector2i(target.global_position)
	
	assert(target.exit_exists[opposing_dir], 
	"Attempted to place room at nonexistent exit.")
	assert(exit_exists[dir],
	"No compatible exit to connect to the room.")
	placement_location += tilesize * (target.exits[opposing_dir]
						+ DIR_TO_VEC[opposing_dir] 
						- exits[dir])
	global_position = Vector2(placement_location)

## Register the exit locations from the [code]$Exits[/code] to the [member exits] and their presence to [member exit_exists].
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

## Registers the spawn location to [member spawn_location] and whether this room has one in [member has_spawnpoint].
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

## Lists out the registered exit locations in [TileMapLayer] grid. Only for debugging.
func print_exits() -> void:
	print(" ")
	for dir: int in ExitDir.values():
		if exit_exists[dir]:
			print(dir_name(dir) + " = " + str(exits[dir]))
		else:
			print(dir_name(dir) + " = " + "Absent")
	print(" ")
