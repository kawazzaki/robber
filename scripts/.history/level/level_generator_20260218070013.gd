extends Node3D


@export var rooms_scenes : Array[PackedScene]
@export var room_parent : Node


func build():
    pass


func add_start_room():
    var room : Room = rooms_scenes[0].instantiate()
    room_parent.add_child(room)
    
    pass