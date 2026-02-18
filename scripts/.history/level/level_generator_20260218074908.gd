extends Node3D


@export var rooms_scenes : Array[PackedScene]
@export var parent : Node
@export var max_rooms : int = 1
@export var grap : float = 0.15
var rooms = []

const DIRS = [
	Vector3.LEFT,Vector3.RIGHT,Vector3.FORWARD,Vector3.BACK
]

func clear:
	for room in rooms:
		room.clear()
		room.queue_free()
	rooms.clear()


func build():
	DebugConsole.log("start_generating")
	add_start_room()
	generate_rooms()



func add_start_room():
	var room : Room = rooms_scenes[0].instantiate()
	parent.add_child(room)
	room.position = Vector3.ZERO
	room.build()
	rooms.append(room)

func generate_rooms():
	var tries : int = 0

	while rooms.size() < max_rooms and tries < max_rooms * 20:
		tries +=1
		var parent_room : Room = rooms.pick_random()
		if parent_room == null or parent_room.doors.is_empty():
			continue
		var dir = DIRS.pick_random()
		var door_info = parent_room.get_door_by_dir(dir)

		if door_info == null:
			continue
		
		var new_scene = rooms_scenes.pick_random()
		var new_pos = parent_room.global_position - door_info["to_center"] + dir * grap

		parent_room.doors.erase(door_info)
		spawn_room(new_scene,new_pos,dir)


func spawn_room(scene : PackedScene,pos : Vector3,dir : Vector3):
	var room : Room = scene.instantiate()
	parent.add_child(room)

	room.global_position = pos
	room.build()

	if room.get_door_by_dir(-dir):
		var door_info = room.get_door_position_by_dir(-dir)
		room.global_position += door_info["to_center"]
		room.doors.erase(door_info)
	
	rooms.append(room)


func _ready() -> void:
	DebugConsole.add_command("bl",build,self)
