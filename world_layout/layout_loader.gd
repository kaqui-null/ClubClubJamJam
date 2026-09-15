extends Node2D

## Tells the loader where to load the world from.
@export var file_path : String = "res://assets/world_layout.lyt.txt"

var space : Array[Array] = []
var start : Vector2i

## Gets the room-id of the room at the specified [param index], returns [code]null[/code] if none present.
func at(index: Vector2i) -> Variant: 
	if has(index): 
		return space[index.y][index.x]
	else: return null

## Returns [code]true[/code] if there is a room present at specified [param index], returns [code]false[/code] otherwise
func has(index: Vector2i) -> bool: 
	return (
		index.y >= 0 &&
		index.x >= 0 &&
		index.y < space.size() &&
		index.x < space[index.y].size()
	) 

## Sets the room at the specified index to a room with specified [param room_id]. [br][br]
## [b]NOTE:[/b] this does not create new space for rooms, if you try to set a room at an index that 
## does not exist, the operation will return false, indicating failure, returning true indicates success. [br][br]
## Adding support for adding operations that increase the space for rooms is possible, 
## but not currently in scope for this project.
func put(index: Vector2i, room_id: int) -> bool : 
	if has(index) :
		space[index.y][index.x] = room_id
		return true
	return false

## Returns an array of indices with the specified [param room_id].
func locations_of(room_id: int) -> Array[Vector2i]: 
	var indices: Array[Vector2i] = [];

	for row in space.size() :
		for col in space[row].size() :
			if space[row][col] == room_id :
				indices.append(Vector2i(col,row))
	return indices

## Reads in the data from the file. [br]
## [i](after this function returns, the invariants of the layout loader
## are [s]at least in theory[/s] valid). [/i][br][br]
## [b]NOTE:[/b] this is called by the layout manager after all rooms are registered, it should be the final thing
## to run before the invariants of the layout manager are considered valid.
func read() -> void : 
	var file = FileAccess.open(file_path, FileAccess.READ)
	var file_content : Array = Array(file.get_as_text().remove_chars("\r").split("\n",false))
	var control = file_content.pop_front()
	file.close()
	for line in file_content:
		var row : Array[int] = []
		for word : String in line.remove_chars(" ").split(",",false):
			if word.strip_edges().begins_with("'") :
				var packed = word.substr(1).split(":",false)
				if packed.size() == 2 :
					for unit in int(packed[0]) :
						row.push_back(int(packed[1]))
				# TODO, some sort of error here for incorrect packing
			else : row.push_back(int(word))
		space.push_back(row)
	var found = false
	for ctrl : String in control.remove_chars(" ").split(",",false) : 
		if ctrl.strip_edges().begins_with("o") :
			var packed = ctrl.substr(1).split(":",false)
			if packed.size() == 2 :
				start = Vector2i(int(packed[0]), int(packed[1]))
				found = true
				break
			# TODO, some sort of error here for incorrect packing
	if !found :
		start = Vector2i.ZERO
		# TODO, emit some warning that the starting location was improperly initialized 

## Returns the index of the room that the player starts in, [br]
## this is the room that should be loaded first by the layout manager.
func get_start() -> Vector2i : return start
