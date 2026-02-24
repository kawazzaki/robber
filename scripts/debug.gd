extends Node

@export var player_scene : PackedScene


func _ready():
	DebugConsole.add_command("sp",spawn_player,self)




func spawn_player() -> Node:
	var player = player_scene.instantiate()
	get_parent().add_child(player)
	return player