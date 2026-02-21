extends Node



@export var door_scene : PackedScene



func spawn_door(info : Array):
	var door : StaticBody3D  = door_scene.instantiate()
	var room : Room = info[0]
	var door_info : Dictionary = info[1]
	room.add_child(door)
	print(door_info)
	door.global_position = room.global_position - door_info["to_center"] + Vector3.LEFT



func _on_level_finish_build(r: Array , c: Array) -> void:
	for i in c.size():
		spawn_door(c[i])
	pass
