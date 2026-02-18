extends Node


var start_room : Room
var finish_room : Room

var rooms : Array




func _on_finish_build(ROOMS: Array) -> void:
	start_room = ROOMS[0]
    rooms = ROOMS
