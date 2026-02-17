extends State


@export var idle_speed: float
@export var run_speed: float


@export var stand_coll : CollisionShape3D
@export var crouch_coll : CollisionShape3D
@export var uncrouch_raycast : RayCast3D



var cold_time : float = 1
var timer : float 

var crouch_state : String = "idle"

func enter():
	timer = cold_time
	player_controller.is_crouching = true
	player_controller.is_sprinting = false
	crouch_coll.disabled = false
	stand_coll.disabled = true
	player_controller.head.position -= Vector3(0,1,0)

func exit():
	stand_coll.disabled = false
	crouch_coll.disabled = true
	player_controller.is_crouching = false
	player_controller.head.position += Vector3(0,1,0)

func update():
	timer -= float(1)/60
	if player_controller.move_dir != Vector2.ZERO:
		player_controller.move_speed = run_speed
		crouch_state = "move"
	else:
		player_controller.move_speed = idle_speed
		crouch_state = "idle"

	if Input.is_action_just_pressed("crouch") and player_controller.is_crouching and can_stand() and timer < 0:
		state_machine.change_state(player_controller.idle)

func physics_update():
	var basis = player_controller.global_transform.basis
	var forward = basis.z
	var right = basis.x
	var direction: Vector3 = Vector3.ZERO
	if player_controller.move_dir != Vector2.ZERO:
		direction = (player_controller.move_dir.x * right + player_controller.move_dir.y * forward).normalized()
		player_controller.velocity.x = direction.x * player_controller.move_speed
		player_controller.velocity.z = direction.z * player_controller.move_speed
	else:
		player_controller.velocity = Vector3.ZERO
	



func can_stand():
	if uncrouch_raycast:
		if uncrouch_raycast.is_colliding():
			var other : StaticBody3D = uncrouch_raycast.get_collider()
			if other.is_in_group("obstacle"):
				return false
	return true