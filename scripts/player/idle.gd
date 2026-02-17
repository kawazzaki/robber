extends State


var idle_speed : float = 0


func enter():

    player_controller.move_speed = idle_speed
    player_controller.velocity = Vector3.ZERO



func update():
    if player_controller.move_dir != Vector2.ZERO:
        state_machine.change_state(player_controller.run)
    if player_controller.is_on_floor() and Input.is_action_just_pressed("jump"):
        state_machine.change_state(player_controller.jump)
