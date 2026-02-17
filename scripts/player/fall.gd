extends State

@export var gravity_scale : float = 2





func update():
    if player_controller.is_on_floor()  :
        if player_controller.move_dir != Vector2.ZERO:
            state_machine.change_state(player_controller.run)
            return
        state_machine.change_state(player_controller.idle)
        pass


func physics_update():
    player_controller.velocity.y -= gravity_scale