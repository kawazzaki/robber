extends StaticBody3D

class_name InteractableObject

var lookMe = false

func interact_start(): lookMe = true
func interact_update(): pass
func interact_exit(): lookMe = false


func interact(player: Player):
    interact_rpc.rpc(player.name.to_int())

@rpc("any_peer","call_local", "reliable")
func interact_rpc(player_id : int):
    if multiplayer.is_server():
        DebugConsole.log("player "+str(player_id) + " interact with " + name)

func _process(delta: float) -> void:
    if lookMe:
        DebugDraw3D.draw_text(self.global_position + Vector3.UP + Vector3.FORWARD, name, 72, Color.RED)