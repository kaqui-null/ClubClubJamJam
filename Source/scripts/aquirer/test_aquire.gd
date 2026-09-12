extends StaticBody2D

func aquire_condition() -> bool : 
	print("condition checked")
	return Input.is_mouse_button_pressed(1) 

func aquire() :
	print("aquired")
