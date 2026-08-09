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
			#for row in repr : row.push_front(inc)
			for row in repr : row.push_front(0)
			#for row_idx in repr.size() : repr[row_idx].push_front(Vector2i(start.x,row_idx-start.y))
			print("push left")
		
		while idx.x >= width+start.x :
			width += 1
			#for row in repr : row.push_back(inc)
			for row in repr : row.push_back(0)
			#for row_idx in repr.size() : repr[row_idx].push_back(Vector2i(width+start.x,row_idx-start.y))
			print("push right")
		
		while idx.y < start.y :
			start.y -= 1
			height += 1
			var array : Array = []
			for unit in range(0, width) : 
				#array.push_back(inc)
				array.push_back(0)
				#array.push_back(Vector2i(unit+start.x,start.y+height))
			repr.push_front(array)
			print("push top")
		
		while idx.y >= height+start.y :
			height += 1
			var array : Array = []
			for unit in range(0, width) : 
				#array.push_back(inc)
				array.push_back(0)
				#array.push_back(Vector2i(unit+start.x,start.y+height))
			repr.push_back(array)
			print("push bottom")
		
		#repr[idx.y-start.y][idx.x-start.x] = id_from_coords(get_cell_atlas_coords(idx))
		#repr[-start.y][-start.x] = 1
		
		#if (
			#(idx.y-start.y >= 0) && 
			#(idx.y-start.y < repr.size()) && 
			#(idx.x-start.x >= 0) && 
			#(idx.x-start.x < repr[idx.y-start.y].size())
		#):
		repr[idx.y-start.y][idx.x-start.x] = id_from_coords(get_cell_atlas_coords(idx))
		
		print(str(idx))
		print("start"+str(start))
		print("dim("+str(width)+", "+str(height)+")")
		for row in repr :
			var tem = ""
			for chr in row :
				tem+= "_" if chr == 0 else "@"
				#tem+=str(chr)+", "
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

func kready():
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
		
		var updated = repr[cell_pos.y-start_height]#.replace("!"+str(cell_pos.x),str(id_from_coords(get_cell_atlas_coords(cell_pos))))
		repr[cell_pos.y-start_height] = updated
		if dbg : print(updated)
	print(repr)
	
	var file = FileAccess.open("res://assets/world_layout.lyt.txt", FileAccess.WRITE)
	file.store_string(
		"s"+str(start_room_idx.x)+":"+str(start_room_idx.y)+
		", o"+str(start_room_idx.x-start_width-1)+":"+str(start_room_idx.y-start_height-1)+
		", w"+str(abs(start_width)+abs(end_width)+1)+
		", t"+str(start_height)+
		", l"+str(start_width)+
		", \n"
	)
	for rep in repr :
		if dbg : print(rep)
		var proccessable : PackedStringArray = rep.split(", ")
		var temp : String = ""
		var deb : String = ""
		var count : int = 0
		for to_proc_idx : int in range(0, proccessable.size()) :
			var last : bool = to_proc_idx == proccessable.size()-1
			var to_proc : int = dexclaim(proccessable[to_proc_idx])
			var next_proc : int = dexclaim(proccessable[to_proc_idx+(0 if last else 1)])
			
			deb+= "_" if to_proc == 0 else "@"
			
			count+=1
			if last or to_proc != next_proc :
				if count > 1 :
					temp+="'"+str(count)+":"+str(to_proc)+", "
				else : temp+=str(to_proc)+", "
				count = 0
		if dbg : print(temp)
		print(deb)
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

#11=a
#10=b
#3=c
#16=d
#15=e
#4=f
#g=0

#s3:3, o4:4, w4, t-2, l-2, 
#aabc_ 
#dd_e_ 
#d__e_ 
#fbbg_ 

#6=a
#10=b
#47=c
#15=d
#36=e
#11=f
#29=g
#3=h
#47=i
#7=j
#56=k
#38=l
#37=m
#36=n
#4=o
#68=p
#28=q
#21=r
#30=s
#1=t
#2=u
#46=v

#s3:3, o6:5, w9, t-2, l-3, 
#___abb 
#__ac__ 
#__de_____ 
#_fghij___ 
#_dfkblbbj 
#fmnopbqrs 
#dobbbbjtu 
#___obbvbb 
#______oq_
