extends MeshInstance2D
#extends CanvasItem

@export var player : Node2D
@export var light : Node2D

var camera : Camera2D 

func _ready() -> void:
	camera = player.get_cam()

func _process(_delta: float) -> void:
	if not camera:
		return
		
	var mat: ShaderMaterial = material as ShaderMaterial
	if mat:
		scale = get_viewport_rect().size
		mat.set_shader_parameter("camera_zoom", camera.zoom)
		mat.set_shader_parameter("screen_size", get_viewport_rect().size)
		mat.set_shader_parameter("light_pos", light.global_position)
		
		var p = get_global_mouse_position()-light.global_position
		var a = ((acos(p.x/sqrt(p.x*p.x+p.y*p.y))+PI/2.)*
				(-1. if p.y >= 0. else 1.)+
				(-PI if p.y >= 0. else 0.))
		
		mat.set_shader_parameter("light_angle", a)
		
		var world_position = get_viewport().get_camera_2d().get_canvas_transform().affine_inverse() * Vector2(0, 0)
		global_position = world_position+scale/2
		
		
