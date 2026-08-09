extends TileMapLayer

@export var file_path : String = "res://assets/world_layout.lyt.txt"
@export var start_room_idx : Vector2i
@export var dbg : bool = !false

func _ready() -> void :
	var repr : Array = [[0]]
	var start : Vector2i = Vector2i.ZERO
	var width: int = 1
	var height: int = 1
	
	for idx : Vector2i in get_used_cells() :
		while idx.x < start.x :
			start.x -= 1
			width += 1
			for row in repr : row.push_front(0)
			if dbg : print("push left")
		
		while idx.x >= width+start.x :
			width += 1
			for row in repr : row.push_back(0)
			if dbg : print("push right")
		
		while idx.y < start.y :
			start.y -= 1
			height += 1
			var array : Array = []
			for unit in range(0, width) : 
				array.push_back(0)
			repr.push_front(array)
			if dbg : print("push top")
		
		while idx.y >= height+start.y :
			height += 1
			var array : Array = []
			for unit in range(0, width) : 
				array.push_back(0)
			repr.push_back(array)
			if dbg : print("push bottom")
		
		repr[idx.y-start.y][idx.x-start.x] = id_from_coords(get_cell_atlas_coords(idx))
		
		if dbg : 
			print(str(idx))
			print("start"+str(start))
			print("dim("+str(width)+", "+str(height)+")")
			for row in repr :
				var tem = ""
				for chr in row :
					tem+= "_" if chr == 0 else "@"
				print(tem)
			print("\n")
	
	file_write(repr, start)

func file_write(repr: Array, start: Vector2i) -> void :
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(
		"s"+str(start_room_idx.x)+":"+str(start_room_idx.y)+
		", o"+str(start_room_idx.x-start.x-1)+":"+str(start_room_idx.y-start.y-1)+
		", \n"
	)
	for rep in repr :
		var temp : String = ""
		var count : int = 0
		for to_proc_idx : int in range(0, rep.size()) :
			var last : bool = to_proc_idx == rep.size()-1
			var to_proc : int = rep[to_proc_idx]
			var next_proc : int = rep[to_proc_idx+(0 if last else 1)]
			
			count+=1
			if last or to_proc != next_proc :
				if count > 1 :
					temp+="'"+str(count)+":"+str(to_proc)+", "
				else : temp+=str(to_proc)+", "
				count = 0
		if dbg : print(temp)
		file.store_string(temp+"\n")
	file.close()

func id_from_coords(pos: Vector2i) -> int:
	return sum(pos.x+pos.y)+pos.y

func sum(i: int) -> int :
	var temp = 0
	for j in range(0, i+1) :
		temp+=j
	return temp
