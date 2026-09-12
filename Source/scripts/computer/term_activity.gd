extends Computor.Activity

@export var cursor_frames : int = 35
@export_multiline(" ") var help : String;
@export_multiline(" ") var system : String;

var command : String = "";

func startup(compter: Computor) -> void:
	compter.vprints("Welcome\nrun \"help\" to list available commands.\n>")

var cursor_timer : int = cursor_frames
var cursor_code : bool = false
func update(compter: Computor) -> void:
	cursor_timer -= 1
	if cursor_timer <= 0 :
		cursor_timer = cursor_frames
		cursor_code = !cursor_code
	compter.cursor = compter.vprints_chr(compter.code("_" if cursor_code else " "), compter.background, compter.foreground, compter.cursor)-1

func input(
		compter: Computor, 
		typed: String, 
		keycode: String,
		_shift: bool,
		_alt: bool,
		_meta: bool,
		_ctrl: bool,
	) -> void: 
		if typed == "backspace" :
			if command.length() > 0 :
				compter.cursor = compter.vprint_chr(compter.code(" "), compter.cursor)-1
				compter.vbackspace(1)
				command = command.substr(0,command.length()-1)
		elif keycode == "Enter" :
			compter.cursor = compter.vprint_chr(compter.code(" "), compter.cursor)-1
			var _exit : int = run(compter, command.strip_edges())
			command = ""
			compter.cursor = compter.cursor_nl(compter.cursor)
			#compter.vprints("\\@f"+str(3 if exit > 0 else 8)+"\\"+str(exit))
			compter.vprints(">")
		else :
			compter.vprints(typed)
			command += typed

func run(compter: Computor, command: String) -> int :
	var tokens : Array[String] = lex(command)
	
	compter.cursor = compter.cursor_nl(compter.cursor)
	
	if tokens.size() == 0 :
		return 0
	
	match tokens[0] :
		"help" : 
			compter.vprints(help)
			return 0
		"system" : 
			compter.vprints(system)
			return 0
		"clear" : 
			compter.cursor = compter.vclear()
			return 0
		"reboot" : 
			compter.push_activity("reboot")
			return 0
		"fore" : 
			if tokens.size() == 2 :
				compter.vfores(int(tokens[1]))
				compter.foreground = int(tokens[1])
				return 0
			else : 
				compter.vprints("\\@f3\\fore requires an int for color")
				return 2
		"back" : 
			if tokens.size() == 2 :
				compter.vbacks(int(tokens[1]))
				compter.background = int(tokens[1])
				return 0
			else : 
				compter.vprints("\\@f3\\back requires an int for color")
				return 2
	
	compter.vprints("\\@f3\\command not found")
	return 1

func lex(unl: String) -> Array[String] :
	var temp : Array[String] = []
	var stringing : bool = false
	var record : String = ""
	var slashes : int = 0
	for chr in unl :
		if chr == "\"" :
			if stringing:
				if slashes % 2 == 0 :
					stringing = false
				else : record += chr
			else :
				stringing = true
		elif !stringing && chr == " " && record.length() > 0 :
			temp.push_back(record)
			record = "" 
		else :
			record += chr
		if chr == "/" : slashes += 1
		else : slashes = 0
	if record.length() > 0 : temp.push_back(record)
	return temp
