
extends InteractableObject


class_name Item

@export var isCondition : bool
@export var condition_name : String

func interact(player : Player):
    super.interact(player)

    interact_rpc.rpc(player.name)
    if isCondition and condition_name:
        player.interact_system.requirement = condition_name
        DebugConsole.log(str(player.name)+" inventory contain : " + str(player.interact_system.requirement) )
    
@rpc("any_peer","call_local","reliable")
func interact_rpc(player_name : String):
    var id = str(player_name).to_int()
    take_item()

func take_item():
    self.queue_free()


func _process(delta: float) -> void:
    DebugDraw3D.draw_text(global_position + Vector3.UP  ,condition_name,32,Color.BLUE_VIOLET)