extends Node



@onready var player : Player = self.get_parent()


var requirement : String = "key"


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player.aim_raycast:
		if player.aim_raycast.current_interactable:
			player.aim_raycast.current_interactable.interact(player)
