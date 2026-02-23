extends CharacterBody3D


class_name Player


@export_category("Components")
@export var state_machine : StateMachine
@export var head : Node3D
@export var aim_raycast : RayCast3D
@export var interact_system : Node
@export_category("States")
@export var s_idle : State
@export var s_run : State






var move_speed : float = 10
var rotation_speed : float = 1
var moveInput : Vector2


func _ready() -> void:
	state_machine.change_state(s_idle)

func _process(delta: float) -> void:
	moveInput = Input.get_vector("left","right","up","down").normalized()

	if Input.is_action_just_pressed("toggle"):
		Global.toggle_mouse()



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Global.is_captured == true:

		rotate_y(.001 * - event.relative.x * rotation_speed)
		head.rotate_x(.001 *-event.relative.y * rotation_speed)
		head.rotation_degrees.x = clamp(head.rotation_degrees.x,-90 ,90)







func player_move():
	if moveInput == Vector2.ZERO:return
	var forward = transform.basis.z
	var right = transform.basis.x
	var moveDir = (forward * moveInput.y + right * moveInput.x)*move_speed
	velocity = moveDir
	move_and_slide()
	pass
