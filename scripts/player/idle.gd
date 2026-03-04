extends State



@export var anim_name : String

func update(delta :float):
    

    player.animator.play(anim_name)
    player.player_mesh.rotation.y = PI
    if player.moveInput != Vector2.ZERO:
        state_machine.change_state(player.s_run)



