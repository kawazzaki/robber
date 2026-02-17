extends StaticBody3D


class_name  interactOBJ

var lookMe = false

func on_aim_enter(player : Player):lookMe = true
func on_aim_exit():lookMe = false

func interact(player:Player):print(name)



