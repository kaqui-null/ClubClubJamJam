extends Computor.Activity;

@export_multiline(" ") var computery_bullshit : String = ""

var line : int = 0

func startup(compter: Computor) -> void: 
	compter.cursor = compter.vclear()
	line = 0

func update(compter: Computor) -> void: 
	var compe : Array = Array(computery_bullshit.split("\n"))
	if line >= compe.size() :
		compter.pop_activity()
		compter.cursor = compter.vclear()
		compter.vprints(compter.startup_message)
		compter.activities[compter.active.back()].startup(compter)
	else :
		compter.vprints(compe[line]+"\n")
		line+=1

func input(
		_compter: Computor, 
		_typed: String, 
		_keycode: String,
		_shift: bool,
		_alt: bool,
		_meta: bool,
		_ctrl: bool,
	) -> void: pass # input is not needed
