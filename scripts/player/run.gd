extends State


@export var run_speed: float
@export var sprint_speed : float


func update():

	if Input.is_action_pressed("sprint") :
		player_controller.is_sprinting = true
		player_controller.move_speed = sprint_speed
	else:
		player_controller.move_speed = run_speed
		player_controller.is_sprinting = false

	###############
	if player_controller.move_dir == Vector2.ZERO:
		state_machine.change_state(player_controller.idle)
	if player_controller.is_on_floor() and Input.is_action_just_pressed("jump"):
		state_machine.change_state(player_controller.jump)


func physics_update():
	var basis = player_controller.global_transform.basis
	var forward = basis.z
	var right = basis.x

	var direction: Vector3 = Vector3.ZERO

	if player_controller.move_dir != Vector2.ZERO:
		direction = (player_controller.move_dir.x * right + player_controller.move_dir.y * forward).normalized()

		player_controller.velocity.x = direction.x * player_controller.move_speed
		player_controller.velocity.z = direction.z * player_controller.move_speed


func exit():
	player_controller.is_sprinting = false
