extends InteractableObject


signal border_removed(border : InteractableObject)

var center : Node3D
var door: InteractableObject
@export var condition: String

func _ready() -> void:
	center = self.get_parent()

	door = center.get_parent()
	pass


func interact(player : Player):
	if player.interact_system.requirement != condition : return
	remove_border.rpc()


@rpc("any_peer","call_local","reliable")
func remove_border():
	self.queue_free()
	if center.get_children().size() == 1:
		door.has_borders = false
