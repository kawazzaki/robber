extends State



@export var jump_force : float


func enter():
	player_controller.velocity.y += jump_force
