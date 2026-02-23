extends Node3D

class_name Level

signal finish_build(r : Array , c : Array)

@export var start_room_scene : PackedScene
@export var rooms_scenes : Array[PackedScene]
@export var parent : Node
@export var max_rooms : int = 1
@export var grap : float = 0.3




var rooms = []

const SCALES = [
	Vector3(1,1,1),Vector3(1,1,-1),Vector3(-1,1,1)
]

var connections = []
var rng = RandomNumberGenerator.new()

func clear():
	for room in rooms:
		room.clear()
		room.queue_free()
	rooms.clear()
	connections.clear()

func build():
	rng.seed = Global.seed
	clear()
	add_start_room()
	await generate_rooms()
	finish_build.emit(rooms, connections)

func add_start_room():
	var room : Room = start_room_scene.instantiate()
	parent.add_child(room)
	room.position = Vector3.ZERO
	rotate_room(room)
	room.build(rng)  # pass the shared rng
	rooms.append(room)

func rotate_room(room : Room):
	room.scale = SCALES[rng.randi_range(0, SCALES.size() - 1)]

func generate_rooms() -> void:
	await _generate_rooms_async()

func _generate_rooms_async():
	var tries : int = 0
	var queue : Array = [rooms[0]]

	while rooms.size() < max_rooms and tries < max_rooms * 200:
		tries += 1

		while not queue.is_empty():
			if not is_instance_valid(queue[0]) or queue[0].doors.is_empty():
				queue.pop_front()
			else:
				break

		if queue.is_empty():
			break

		var parent_room : Room = queue[0]
		if not is_instance_valid(parent_room):
			continue

		var door_info = parent_room.doors[rng.randi_range(0, parent_room.doors.size() - 1)]
		var dir = door_info["dir"]

		var new_scene = pick_different_room(parent_room)
		var new_pos = parent_room.global_position - door_info["to_center"] + dir * grap
		var spawned = await spawn_room(new_scene, new_pos, dir, parent_room)

		if not is_instance_valid(parent_room):
			continue

		if spawned:
			parent_room.doors.erase(door_info)
			queue.append(rooms.back())
		else:
			parent_room.doors.erase(door_info)
			if parent_room.doors.is_empty():
				queue.pop_front()

func pick_different_room(parent_room : Room) -> PackedScene:
	var filtered = rooms_scenes.filter(func(scene):
		var temp = scene.instantiate()
		var type = temp.room_type
		temp.free()
		return type != parent_room.room_type
	)
	if filtered.is_empty():
		return rooms_scenes[rng.randi_range(0, rooms_scenes.size() - 1)]
	return filtered[rng.randi_range(0, filtered.size() - 1)]

func spawn_room(scene : PackedScene, pos : Vector3, dir : Vector3, parent_room : Room) -> bool:
	var room : Room = scene.instantiate()
	parent.add_child(room)

	room.global_position = pos
	room.build(rng)  # pass the shared rng

	var door_info : Dictionary = room.get_door_by_dir(-dir, rng)  # pass shared rng
	var rotate_tries := 0
	while door_info.is_empty() and rotate_tries < 10:
		rotate_tries += 1
		rotate_room(room)
		room.clear()
		room.build(rng)
		door_info = room.get_door_by_dir(-dir, rng)

	if door_info.is_empty():
		room.queue_free()
		return false

	room.global_position += door_info["to_center"]

	if not await can_spawn(room):
		room.queue_free()
		return false

	room.doors.erase(door_info)
	rooms.append(room)
	parent_room.children.append(room)
	room.parent = parent_room
	connections.append([room, door_info])
	return true

func can_spawn(room : Room):
	var detector : Area3D = room.get_node("detector")
	await get_tree().physics_frame
	await get_tree().physics_frame
	var bodies = detector.get_overlapping_bodies()
	detector.queue_free()
	for b in bodies:
		if b != room:
			return false
	room.get_node("coll").disabled = false
	return true