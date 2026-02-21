extends State





func update(delta :float):
    if player.moveInput != Vector2.ZERO:
        state_machine.change_state(player.s_run)