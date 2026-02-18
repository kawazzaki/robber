extends Node3D


@export var rooms_scenes : Array[PackedScene]
@export var room_parent : Node


var rooms = []

func build():
	add_start_room()
	pass


func add_start_room():
	var room : Room = rooms_scenes[0].instantiate()
	room_parent.add_child(room)
	room.position = Vector3.ZERO
	room.build()
	rooms.append(room)

func _ready() -> void:
	DebugConsole.add_command("build_level",build,self)
