extends Node


var is_captured = false


func toogle_capture():
    if Input.is_action_just_pressed("toggle"):
        if is_captured:
            is_captured = false
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            is_captured = true
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _process(delta: float) -> void:
    toogle_capture()