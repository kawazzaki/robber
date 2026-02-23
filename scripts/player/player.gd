extends CharacterBody3D


class_name Player


@export_category("Components")
@export var state_machine : StateMachine
@export var head : Node3D
@export var aim_raycast : RayCast3D
@export var interact_system : Node
@export var camera : Camera3D
@export_category("States")
@export var s_idle : State
@export var s_run : State






var move_speed : float = 10
var rotation_speed : float = 1
var moveInput : Vector2


func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if !is_multiplayer_authority():
		camera.queue_free()
		return
	camera.current = true
	DebugConsole.log(str(is_multiplayer_authority()))
	state_machine.change_state(s_idle)

func _process(delta: float) -> void:
	if !is_multiplayer_authority():return
	moveInput = Input.get_vector("left","right","up","down").normalized()
	



func _unhandled_input(event: InputEvent) -> void:
	if !is_multiplayer_authority():return
	if event is InputEventMouseMotion and Global.is_captured == true :

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
