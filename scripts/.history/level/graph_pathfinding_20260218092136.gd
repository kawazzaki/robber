extends Node


var start_room : Room
var finish_room : Room

var rooms : Array[Room]

func get_farthest_room():
	var farthest_dis = 0
	for x in rooms:
		for z in rooms:
			if x == z:
				continue
			var current _dist = x.global_position.distance_to(z.global_position
			if 
	pass


func _on_finish_build(ROOMS: Array) -> void:
	start_room = ROOMS[0]
	rooms = ROOMS
