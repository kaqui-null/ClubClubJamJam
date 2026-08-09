extends Node2D

# tells the loader where to load the world from
@export var file_path : String = "res://assets/world_layout.lyt.txt"

# gets the room-id of the room at the specified index, returns null if there is no room at specified index 
func at(index: Vector2i) -> int? : return null

# returns true if there is a room present at specified index, returns false otherwise
func has(index: Vector2i) -> bool : pass

# sets the room at the specified index to a room with specified room_id
# NOTE: this does not create new space for rooms, if you try to set a room at an index that does not
# exist, the operation will return false, indicating failure, returning true indicates success.
# adding support for adding operations that increase the space for rooms is possible, but
# not currently in scope for this project
func put(index: Vector2i, room_id: int) -> bool : pass

# gets the first room with the specified room_id, returns null if one cannot be found
func index_of(room_id: int) -> Vector2i? : pass

# reads in the data from the file (after this function returns, the invariants of the layout loader are 
# (at least in theory) valid).
# NOTE: this is called by the layout manager after all rooms are registered, it should be the final thing
# to run before the invariants of the layout manager are considered valid.
func read() -> void : pass

# returns the index of the room that the player starts in, this is the room that should be loaded
# first by the layout manager
func get_start() -> Vector2i : pass
