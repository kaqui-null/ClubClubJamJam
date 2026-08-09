extends Node2D

# tells the loader where to load the world from
@export var file_path : String = "res://assets/world_layout.lyt.txt"

var space : Array = []
var start : Vector2i

# gets the room-id of the room at the specified index, returns null if there is no room at specified index 
func at(index: Vector2i) -> Variant: 
	if has(index): 
		return space[index.y][index.x]
	else : return null

# returns true if there is a room present at specified index, returns false otherwise
func has(index: Vector2i) -> bool : 
	return (
		index.y >= 0 &&
		index.x >= 0 &&
		index.y < space.size() &&
		index.x < space[index.y].size()
	) 

# sets the room at the specified index to a room with specified room_id
# NOTE: this does not create new space for rooms, if you try to set a room at an index that does not
# exist, the operation will return false, indicating failure, returning true indicates success.
# adding support for adding operations that increase the space for rooms is possible, but
# not currently in scope for this project
func put(index: Vector2i, room_id: int) -> bool : 
	if has(index) :
		space[index.y][index.x] = room_id
		return true
	return false

# gets the first room with the specified room_id, returns null if one cannot be found
func index_of(room_id: int) -> Variant: 
	for row in space.size() :
		for col in space[row].size() :
			if space[row][col] == room_id :
				return Vector2i(col,row)
	return null

# reads in the data from the file (after this function returns, the invariants of the layout loader are 
# (at least in theory) valid).
# NOTE: this is called by the layout manager after all rooms are registered, it should be the final thing
# to run before the invariants of the layout manager are considered valid.
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
		# TODO, emmit some warning that the starting location was improperly initialized 

# returns the index of the room that the player starts in, this is the room that should be loaded
# first by the layout manager
func get_start() -> Vector2i : return start
