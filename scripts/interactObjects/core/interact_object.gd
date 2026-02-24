extends StaticBody3D

class_name InteractableObject

var lookMe = false

func interact_start(): lookMe = true
func interact_update(): pass
func interact_exit(): lookMe = false

func interact(player : Player):
    DebugConsole.log(player.name + " interact with " + self.name)
