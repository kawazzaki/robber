extends Node

@export var door_scene: PackedScene
@export var wall_scene: PackedScene

var _occupied_positions: Array[Vector3] = []


func build_finished(connections: Array, rooms: Array, rng: RandomNumberGenerator) -> void:
	_occupied_positions.clear()

	# Collect both sides of every connection (child door pos + matching parent link point)
	for info in connections:
		var child_room: Room = info[0]
		var door_info: Dictionary = info[1]

		# The child side: where the door sits (entry point from child's perspective)
		var child_link_pos: Vector3 = child_room.global_position - door_info["to_center"] + door_info["dir"] * 0.3
		_occupied_positions.append(child_link_pos)

		# The parent side: the parent room has a link point facing the opposite direction
		# at roughly the same world position
		var parent_room: Room = child_room.parent
		if parent_room:
			var matching := _find_closest_link_point(parent_room, child_link_pos)
			if matching:
				_occupied_positions.append(matching.global_position)

	# Spawn doors
	for i in connections.size():
		spawn_door(connections[i], i, rng)

	# Spawn walls, skipping both sides of every doorway
	for room in rooms:
		spawn_walls(room)


func _find_closest_link_point(room: Room, world_pos: Vector3) -> Node3D:
	var closest: Node3D = null
	var closest_dist := INF
	for link_point in room.get_node("links").get_children():
		var d = link_point.global_position.distance_to(world_pos)
		if d < closest_dist:
			closest_dist = d
			closest = link_point
	if closest_dist < 1.0:  # only accept if reasonably close
		return closest
	return null


func spawn_door(info: Array, index: int, rng: RandomNumberGenerator) -> void:
	var room: Room = info[0]
	var door_info: Dictionary = info[1]

	var door: StaticBody3D = door_scene.instantiate()
	var dir: Vector3 = -door_info["dir"]
	var angle := atan2(dir.x, dir.z)

	room.get_node("doors").add_child(door)
	door.global_rotation.y = angle
	door.open_side = 1 if dir.x > 0 else -1
	door.global_position = room.global_position - door_info["to_center"] + door_info["dir"] * 0.3 - door.transform.basis.x
	door.name = "door" + str(index)


func spawn_walls(room: Room) -> void:
	for link_point in room.get_node("links").get_children():
		if _is_occupied(link_point.global_position):
			continue
		var wall = wall_scene.instantiate()
		link_point.get_parent().add_child(wall)
		wall.global_position = link_point.global_position

		# Orient wall to face outward, same logic as door angle calculation
		var dir: Vector3 = -link_point.global_transform.basis.z  # link point's forward
		wall.global_rotation.y = atan2(dir.x, dir.z)

func _is_occupied(pos: Vector3) -> bool:
	for occupied_pos in _occupied_positions:
		if pos.distance_to(occupied_pos) < 1.0:
			return true
	return false
