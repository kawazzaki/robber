extends Node

@export var door_scene : PackedScene

func spawn_door(info : Array):
	var door : StaticBody3D = door_scene.instantiate()
	var room : Room = info[0]
	var door_info : Dictionary = info[1]

	# Set rotation BEFORE add_child so door._ready() captures the correct original_rotation
	var dir : Vector3 = door_info["dir"]
	var angle_y : float = atan2(dir.x, dir.z)
	door.rotation = Vector3(0, angle_y, 0)
	

	room.add_child(door)

	# Use the door's local left axis so the hinge offset rotates with the door direction
	var local_left : Vector3 = -door.global_transform.basis.x
	door.global_position = room.global_position - door_info["to_center"] + local_left

func _on_level_finish_build(r: Array, c: Array) -> void:
	for i in c.size():
		spawn_door(c[i])