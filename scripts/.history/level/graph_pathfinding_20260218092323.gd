extends Node


var start_room : Room
var finish_room : Room

var rooms : Array

func get_farthest_room():
	var farthest_dis = 0
	var farthest_room : Room = null
	
	if start_room:
		for r : Room in rooms:
			if r == start_room:
				continue
			var current_dist = start_room.global_position.distance_to(r.global_position)
			if current_dist > farthest_dis:
				
	pass


func _on_finish_build(ROOMS: Array) -> void:
	start_room = ROOMS[0]
	rooms = ROOMS
