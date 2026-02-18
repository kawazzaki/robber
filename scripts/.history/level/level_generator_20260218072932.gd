extends Node3D


@export var rooms_scenes : Array[PackedScene]
@export var parent : Node
@export var max_rooms : int = 1

var rooms = []

func build():
	add_start_room()



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
		


func _ready() -> void:
	DebugConsole.add_command("build_level",build,self)
