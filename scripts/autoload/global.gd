extends Node


var is_captured = false

var seed : int

func toggle_mouse() -> void:
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        is_captured = false
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        is_captured = true