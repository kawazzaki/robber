extends CharacterBody3D

class_name Player


@export var state_machine : StateMachine
@export var head : Node3D
@export var aim_raycast : RayCast3D
@export_category("player states")
@export var idle : State
@export var run : State
@export var jump : State
@export var fall : State
@export var crouch : State
@export_category("variables")
@export var rotation_speed : float ;

var move_speed : float
var move_dir : Vector2
var is_sprinting = false
var is_crouching = false




func inputs_manager():
	move_dir = Input.get_vector("left","right","up","down")



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Global.is_captured:
		rotate_y(.001 * -rotation_speed * event.relative.x)
		head.rotate_x(.001 * -rotation_speed * event.relative.y)
		head.rotation_degrees.x = clamp(head.rotation_degrees.x,-90 , 90)
	pass


func _ready() -> void:
	if state_machine != null:
		state_machine.change_state(idle)

func _process(delta: float) -> void:
	inputs_manager()
	if !is_on_floor():
		state_machine.change_state(fall)
	
	if Input.is_action_just_pressed("crouch") :
		state_machine.change_state(crouch)





func _physics_process(delta: float) -> void:
	move_and_slide()
