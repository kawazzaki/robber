extends Node


var start_room : Room
var finish_room : Room

var rooms : Array

func get_farthest_room():
	var farthest_dis = INF
	for x in rooms:
		for z in rooms:
			if x == z:
				continue
			
	pass


func _on_finish_build(ROOMS: Array) -> void:
	start_room = ROOMS[0]
	rooms = ROOMS
