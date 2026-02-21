extends Node

@export var door_scene : PackedScene
func spawn_door(info : Array):
	var door : StaticBody3D = door_scene.instantiate()
	var room : Room = info[0]
	var door_info : Dictionary = info[1]
	


	var angle = atan2(-door_info["dir"].x,-door_info["dir"].z)
	door.global_rotation.y = angle
	room.add_child(door)
	door.global_position = -door_info["to_center"] + room.global_position - door.transform.basis.x  + door_info["dir"] * 0.3


func _on_level_finish_build(r: Array, c: Array) -> void:
	for i in c.size():
		spawn_door(c[i])
