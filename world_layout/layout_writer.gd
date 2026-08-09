extends TileMapLayer

@export var start : Vector2i
@export var dbg : bool = !false

func _ready():
	# start_dim is the width and height in the ..0 direction
	var start_width: int = 0
	var start_height: int = 0
	# end_dim is the width and height in the 0=.. direction
	var end_width: int = 0
	var end_height: int = 0
	# repr is the final string file of the map
	# each string is a y level, each x is mentioned in the string
	# that the cells y level refers to
	var repr: Array[String] = ["!0, "]
	for cell_pos : Vector2i in get_used_cells() :
		print(cell_pos)
		while cell_pos.y > end_height :
			# add new placeholder row to 0=..
			end_height += 1
			var gend : String = ""
			for idx : int in range(start_width, end_width+1):
				gend += "!"+str(start_width+idx)+", "
			repr.push_back(gend)
			if dbg : print("y>end, pushing back "+str(end_height))
		while cell_pos.y < start_height :
			# add new placeholder row to ..0
			start_height -= 1
			var gend : String = ""
			for idx : int in range(start_width, end_width+1):
				gend += "!"+str(start_width+idx)+", "
			repr.push_front(gend)
			if dbg : print("y<start, pushing front "+str(start_height))
		while cell_pos.x > end_width :
			# add new placeholder col to 0=..
			end_width+=1
			for idx : int in range(0,repr.size()) :
				repr[idx] += "!"+str(cell_pos.x)+", "
			if dbg : print("x>end, pushing right "+str(end_width))
		while cell_pos.x < start_width :
			# add new placeholder col to ..0
			start_width-=1
			for idx : int in range(0,repr.size()) :
				repr[idx] = "!"+str(cell_pos.x)+", " + repr[idx] 
			if dbg : print("x<start, pushing left "+str(start_width))
		
		var updated = repr[cell_pos.y-start_height].replace("!"+str(cell_pos.x),str(id_from_coords(get_cell_atlas_coords(cell_pos))))
		repr[cell_pos.y-start_height] = updated
		if dbg : print(updated)
	
	var file = FileAccess.open("res://assets/world_layout.lyt.txt", FileAccess.WRITE)
	file.store_string(
		"s"+str(start.x)+":"+str(start.y)+
		", w"+str(abs(start_width)+abs(end_width)+1)+
		", \n"
	)
	for rep in repr :
		if dbg : print(rep)
		var proccessable : PackedStringArray = rep.split(", ")
		var temp : String = ""
		var count : int = 0
		for to_proc_idx : int in range(0, proccessable.size()-1) :
			var last : bool = to_proc_idx == proccessable.size()-2
			var to_proc : int = dexclaim(proccessable[to_proc_idx])
			var next_proc : int = dexclaim(proccessable[to_proc_idx+(0 if last else 1)])
			
			count+=1
			if last or to_proc != next_proc :
				if count > 1 :
					temp+="'"+str(count)+":"+str(to_proc)+", "
				else : temp+=str(to_proc)+", "
				count = 0
		if dbg : print(temp)
		file.store_string(temp+"\n")
	file.close()

func dexclaim(to_proc: String) -> int :
	if !to_proc.strip_edges().begins_with("!") : 
		return int(to_proc)
	return 0

func id_from_coords(pos: Vector2i) -> int:
	return sum(pos.x+pos.y)+pos.y

func sum(i: int) -> int :
	var temp = 0
	for j in range(0, i+1) :
		temp+=j
	return temp
