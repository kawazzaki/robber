extends State


@export var anim_name : String





func update(delta :float):
	if player.moveInput == Vector2.ZERO:
		state_machine.change_state(player.s_idle)


func pyhsics_update(delta:float):
	player.animator.play(anim_name)
	
	player.player_mesh.rotation.y = atan2(player.moveInput.x, player.moveInput.y)

	player.player_move()
