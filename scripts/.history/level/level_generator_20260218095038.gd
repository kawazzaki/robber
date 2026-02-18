extends Node3D

signal finish_build(r : Array)

@export var rooms_scenes : Array[PackedScene]
@export var parent : Node
@export var max_rooms : int = 1
@export var grap : float = 0.3
var rooms = []

const DIRS = [
	Vector3.LEFT,Vector3.RIGHT,Vector3.FORWARD,Vector3.BACK
]
const SCALES = [
	Vector3(1,1,1),Vector3(1,1,-1),Vector3(-1,1,1)
]




########
func clear():
	for room in rooms:
		room.clear()
		room.queue_free()
	rooms.clear()


func build():
	clear()
	DebugConsole.log("start_generating")
	add_start_room()
	generate_rooms()

	finish_build.emit(rooms)



func add_start_room():
	var room : Room = rooms_scenes[0].instantiate()
	parent.add_child(room)
	room.position = Vector3.ZERO
	rotate_room(room)
	room.build()
	rooms.append(room)

func rotate_room(room : Room):
	var scale = SCALES.pick_random()
	room.scale = scale


func generate_rooms() -> void:
	await _generate_rooms_async()

func _generate_rooms_async():
	var tries : int = 0

	while rooms.size() < max_rooms and tries < max_rooms * 200:
		tries += 1
		var parent_room : Room = rooms.pick_random()
		if parent_room == null or parent_room.doors.is_empty():
			continue

		var available_doors = parent_room.doors.duplicate()
		if available_doors.is_empty():
			continue

		var door_info = available_doors.pick_random()
		var dir = door_info["dir"]

		var new_scene = rooms_scenes.pick_random()
		var new_pos = parent_room.global_position - door_info["to_center"] + dir * grap

		var spawned = await spawn_room(new_scene, new_pos, dir,parent_room)
		if spawned:
			parent_room.doors.erase(door_info)


func spawn_room(scene: PackedScene, pos: Vector3, dir: Vector3, parent_room: Room) -> bool:
	# 1️⃣ إنشاء الغرفة
	var room: Room = scene.instantiate()
	parent.add_child(room)

	room.global_position = pos
	room.build()

	# 2️⃣ محاولة إيجاد الباب المقابل مع rotation retries
	var door_info = room.get_door_by_dir(-dir)
	var rotate_tries := 0
	while door_info == null and rotate_tries < 10:
		rotate_tries += 1
		rotate_room(room)
		room.clear()
		room.build()
		door_info = room.get_door_by_dir(-dir)

	# 3️⃣ تحقق من نجاح إيجاد الباب
	if door_info == null:
		print("Failed to find matching door after 10 rotations for room:", room.name)
		room.queue_free()
		return false

	# 4️⃣ ضبط موقع الغرفة حسب الباب
	room.global_position += door_info["to_center"]

	# 5️⃣ تحقق من عدم التداخل باستخدام can_spawn
	if not await can_spawn(room):
		print("Room spawn blocked by overlap:", room.name)
		room.queue_free()
		return false

	# 6️⃣ إزالة الباب المستعمل من الغرفة الجديدة
	room.doors.erase(door_info)

	# 7️⃣ إضافة الغرفة للمصفوفات والهيكلية
	rooms.append(room)
	parent_room.children.append(room)
	room.parent = parent_room

	return true

func can_spawn(room : Room):
	var detector : Area3D = room.get_node("detector")
	await get_tree().create_timer(0.2).timeout
	var bodies = detector.get_overlapping_bodies()
	for b in bodies:
		if b != room:
			return false
		print('same room')
	return true

func _ready() -> void:
	DebugConsole.add_command("bl",build,self)
