@tool
class_name Room
extends Node2D

@export var room_properties: RoomProperties:
	set(new_properties):
		if Engine.is_editor_hint():
			update = new_properties.update_exits
			new_properties.Room = self
		room_properties = new_properties
@export_tool_button("Update Exits", "Reload") var update;

func connect_to_room(target: Room, opposing_dir: RoomProperties.ExitDir) -> void:
	var vec_mapped_to_dir := [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
	var tilesize: int = $Exits.tile_set.tile_size.x
	var target_properties := target.room_properties 
	var dir: RoomProperties.ExitDir = target_properties.opposite(opposing_dir)
	var placement_location: Vector2 = target.global_position
	
	assert(target_properties.exit_exists[opposing_dir], 
	"Attempted to place room at nonexistent exit.")
	assert(room_properties.exit_exists[dir],
	"No compatible exit to connect to the room.")
	placement_location += tilesize * Vector2(target_properties.exits[opposing_dir])
	placement_location += tilesize * vec_mapped_to_dir[opposing_dir]
	placement_location -= tilesize * Vector2(room_properties.exits[dir])
	global_position = placement_location

func _ready() -> void:
	if not Engine.is_editor_hint():
		$Exits.visible = false
