extends MeshInstance2D
class_name Computor

# w = 48
# h = 30
# l = 78

@export_category("graphics")

## is the palette used by the renderer,
## note that this must have exactly 16 colors
@export var colors : Array[Color] = [
	# black
	Color(0x00/255.0,0x00/255.0,0x00/255.0), # 0
	# white
	Color(0xff/255.0,0xff/255.0,0xff/255.0), # 1
	# Red
	Color(0xf4/255.0,0x43/255.0,0x36/255.0), # 2
	# Pink
	Color(0xe8/255.0,0x1e/255.0,0x63/255.0), # 3
	# Purple
	Color(0x9c/255.0,0x27/255.0,0xb0/255.0), # 4
	# Deep Purple
	Color(0x67/255.0,0x3a/255.0,0xb7/255.0), # 5
	# Indigo
	Color(0x3f/255.0,0x51/255.0,0xb5/255.0), # 6
	# Blue
	Color(0x21/255.0,0x96/255.0,0xf3/255.0), # 7
	# Light Blue
	Color(0x03/255.0,0xa9/255.0,0xf4/255.0), # 8
	# Teal
	Color(0x00/255.0,0x96/255.0,0x88/255.0), # 9
	# Green 
	Color(0x4c/255.0,0xaf/255.0,0x50/255.0), # 10
	# Light Green
	Color(0x8b/255.0,0xc3/255.0,0x4a/255.0), # 11
	# Lime
	Color(0xcd/255.0,0xdc/255.0,0x39/255.0), # 12
	# Yellow
	Color(0xff/255.0,0xeb/255.0,0x3b/255.0), # 13
	# Orange
	Color(0xff/255.0,0x98/255.0,0x00/255.0), # 14
	# Deep Orange
	Color(0xff/255.0,0x57/255.0,0x22/255.0), # 15
]

## a list of all chars in the charmap, this must list all of them 
## and it must list them exactly, if any that are present in the 
## charmap are not present in this list, rendering will break.
## this is also how the grid understands chars, it uses this
## list to generate char codes that will be stored in the grid
## and sent to the renderer.
## curently there are 71 free chars
@export var char_id : Array[String] = [
	" ",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"+",
	"-",
	"*",
	"/",
	"%",
	"&",
	"|",
	"!",
	"^",
	"=",
	"<",
	">",
	"(",
	")",
	"[",
	"]",
	",",
	".",
	":",
	";",
	"?",
	"'",
	"`",
	"\"",
	"#",
	"$",
	"mid_wire_top_right",
	"mid_wire_top_left",
	"mid_wire_bottom_right",
	"mid_wire_bottom_left",
	"mid_wire_left_right",
	"mid_wire_top_bottom",
	"mid_wire_top_right_bottom",
	"mid_wire_top_left_bottom",
	"mid_wire_left_bottom_right",
	"mid_wire_left_top_right",
	"mid_wire_cross",
	"mid_wire_dot",
	"half_bottom",
	"half_top",
	"half_left",
	"half_right",
	"full_hole",
	"quarter_top_left",
	"quarter_top_right",
	"quarter_bottom_left",
	"quarter_bottom_right",
	"quarters_bottom_left_top_right",
	"quarters_bottom_right_top_left",
	"full",
	"diamonds",
	"spades",
	"hearts",
	"clubs",
	"edge_bottom_left",
	"edge_bottom_right",
	"edge_top_left",
	"edge_top_right",
	"across_bottom_left_top_right",
	"across_bottom_right_top_left",
	"edge_top",
	"edge_bottom",
	"edge_left",
	"edge_right",
	"edge_all",
	"check_left",
	"check_right",
	"check_bottom",
	"check_top",
	"check",
	"check_top_left",
	"check_top_right",
	"check_bottom_left",
	"check_bottom_right",
	"checks_bottom_left_top_right",
	"checks_bottom_right_top_left",
	"ring_bottom_right",
	"ring_bottom_left",
	"ring_top_right",
	"ring_top_left",
	"ring",
	"@",
	"{",
	"}",
	"circle_bottom_right",
	"circle_bottom_left",
	"circle_top_right",
	"circle_top_left",
	"circle",
	"triangle_bottom_right",
	"triangle_bottom_left",
	"triangle_top_right",
	"triangle_top_left",
	"diamond",
	"~", 
	"arrow_up",
	"arrow_right",
	"arrow_down",
	"arrow_left",
	"_",
	"bite_top",
	"bite_right",
	"bite_bottom",
	"bite_left",
	"bite_left_right",
	"bite_top_bottom",
	"bite_center",
	"carat_top",
	"carat_right",
	"carat_bottom",
	"carat_left",
	"diglet_top",
	"diglet_right",
	"diglet_bottom",
	"diglet_left",
	"diglet_top_left",
	"diglet_top_right",
	"diglet_bottom_right",
	"diglet_bottom_left",
	"warning",
	"error",
	"missing",
]

@export var foreground : int = 10
@export var background : int = 0

@export_category("system")

## maps godot input events into the charset that the grid can understand 
@export var keymap : Dictionary = {
	"enter" : "\n",
	"space" : " ",
	"tab" : "    ",
	"shift" : "",
	"ctrl" : "",
	"alt" : "",
	"capslock" : "",
	"meta" : "",
	"escape" : "",
	#"delete" : "",
	"shift+0" : ")",
	"shift+1" : "!",
	"shift+2" : "@",
	"shift+3" : "#",
	"shift+4" : "$",
	"shift+5" : "%",
	"shift+6" : "^",
	"shift+7" : "&",
	"shift+8" : "*",
	"shift+9" : "(",
	"quoteleft" : "`",
	"shift+quoteleft" : "~",
	"minus" : "-",
	"shift+minus" : "_",
	"equal" : "=",
	"shift+equal" : "+",
	"bracketleft" : "[",
	"shift+bracketleft" : "{",
	"bracketright" : "]",
	"shift+bracketright" : "}",
	"backslash" : "/",
	"shift+backslash" : "|",
	"semicolon" : ";",
	"shift+semicolon" : ":",
	"apostrophe" : "'",
	"shift+apostrophe" : "\"",
	"comma" : ",",
	"shift+comma" : "<",
	"period" : ".",
	"shift+period" : ">",
	"slash" : "/",
	"shift+slash" : "?",
}

## the message to display on startup
@export_multiline var startup_message : String = "";
@export var activities : Dictionary[String,Activity] = {};

var bytes : Array[int] = []
var cursor : int = 0;
var active : Array[String] = ["terminal"]

func _ready() -> void:
	var mat: ShaderMaterial = material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("palette", colors)
		mat.set_shader_parameter("chars", num_chars())
	for idx in 1440 :
		bytes.push_back(0)
	vprints(startup_message)
	activities[active.back()].startup(self)

func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var keycode : String = OS.get_keycode_string(event.keycode)
		var keyname : String = ("shift+" if event.shift_pressed else "")+keycode.to_lower()
		# I prefer implicit return ifs to this weird mix with ternary
		var typed : String = (keymap.get(keyname) 
			if keymap.has(keyname) 
			else (keycode 
				if event.shift_pressed else 
					keycode.to_lower()))
		
		activities[active.back()].input(
			self, 
			typed,
			keycode,
			event.shift_pressed,
			event.alt_pressed,
			event.meta_pressed,
			event.ctrl_pressed,
		)

func _process(_delta: float) -> void:
	activities[active.back()].update(self)
	var mat: ShaderMaterial = material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("grid", bytes)

func code(chr : String) -> Variant:
	var id : int = char_id.find(chr)
	@warning_ignore("incompatible_ternary")
	return null if id == -1 else id 

func num_chars() -> int :
	return char_id.size()

func lc_from_cursor(crs: int) -> Vector2i :
	var line : int = floor(crs/48.)
	var col : int = crs-line*48
	return Vector2i(line,col)

func cursor_nl(crs : int) -> int :
	var ind : int = (floor(crs/48.)+1)*48-1
	return cursor_inc(ind)

func cursor_inc(crs : int) -> int :
	var ind : int = crs+1
	while ind >= 1440 :
		shift_up()
		ind -= 48
	return ind

func cursor_pos(x: int, y: int) -> int :
	return clamp(x, 0, 48)+clamp(y, 0, 30)*48;

func shift_up() -> void : 
	for idx : int in bytes.size()-48 :
		bytes[idx] = bytes[idx+48]
	for idx : int in 48 :
		bytes[bytes.size()-idx-1] = 0

func vprints_chr(chr : int, back : int, fore : int, crs : int) -> int :
	var ind : int = cursor_inc(crs-1)+1
	bytes[ind-1] = ((chr & 0xff) << 8) | ((fore & 0xf) << 4) | (back & 0xf)
	return ind

func vprint_chr(chr : int, crs : int) -> int :
	var ind : int = cursor_inc(crs-1)+1
	bytes[ind-1] = bytes[crs] & 0x00ff |((chr & 0xff) << 8)
	return ind

func vprint(text : String) -> void:
	for chr : String in text.replace("\t", "    ") :
		if chr == "\n" : cursor = cursor_nl(cursor)
		else :
			var id : Variant = code(chr)
			if id == null : id = code("missing") 
			cursor = vprint_chr(id, cursor) 

func vprints(text : String) -> void:
	var fore : int = foreground
	var back : int = background
	for survi : String in text.replace("\t", "  ").split("\\") :
		var surv : String = survi.strip_edges()
		if surv.begins_with("*") :
			if surv.contains("star") : cursor = vprints_chr(code("*"), back, fore, cursor) 
			elif surv.contains("at") : cursor = vprints_chr(code("@"), back, fore, cursor) 
			elif surv.contains("char") : cursor = vprints_chr(code("#"), back, fore, cursor) 
			elif surv.contains("space") : cursor = vprints_chr(code(" "), back, fore, cursor) 
			elif surv.contains("nl") : cursor = cursor_nl(cursor)
		elif surv.begins_with("@f") :
			fore = int(surv.substr(1).strip_edges())
		elif surv.begins_with("@b") :
			back = int(surv.substr(1).strip_edges())
		elif surv.begins_with("#") :
			var id : Variant = code(surv.replace("#","").strip_edges())
			if id == null : id = code("missing")
			cursor = vprints_chr(id, back, fore, cursor) 
		else:
			for chr : String in survi :
				if chr == "\n" : cursor = cursor_nl(cursor)
				else : 
					var id : Variant = code(chr)
					if id == null : id = code("missing")
					cursor = vprints_chr(id, back, fore, cursor) 

func vbackspace(amount : int = 1) -> void:
	for _none in amount :
		if cursor > 0 : 
			cursor -= 1
		bytes[cursor] &= 0x00ff

func vclear() -> int :
	for idx in bytes.size() :
		bytes[idx] = 0
	return 0

func vfores(color: int) -> void:
	for idx in bytes.size() :
		bytes[idx] = (bytes[idx] & 0xff0f) | ((color & 0xf) << 4)

func vbacks(color: int) -> void:
	for idx in bytes.size() :
		bytes[idx] = (bytes[idx] & 0xfff0) | (color & 0xf)

func vfore(color: int, crs: int) -> void:
	bytes[crs] = (bytes[crs] & 0xff0f) | ((color & 0xf) << 4)

func vback(color: int, crs: int) -> void:
	bytes[crs] = (bytes[crs] & 0xfff0) | (color & 0xf)

@abstract class Activity extends Node2D :
	@abstract func startup(compter: Computor) -> void;
	@abstract func update(compter: Computor) -> void;
	@abstract func input(
		compter: Computor, 
		typed: String, 
		keycode: String,
		shift: bool,
		alt: bool,
		meta: bool,
		ctrl: bool,
	) -> void;

func push_activity(activity: String) -> bool :
	if activity in activities :
		active.push_back(activity)
		activities[activity].startup(self)
		return true
	else : return false

func pop_activity() -> bool :
	if active.size() > 0 :
		active.pop_back()
		return true
	else : return false




#
