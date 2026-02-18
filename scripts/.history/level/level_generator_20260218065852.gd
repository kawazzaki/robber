extends Node3D


@export var rooms_scenes : Array[PackedScene]



func build():
    pass


func add_start_room():
    var room : room = rooms_scenes[0].instantiate()
    pass