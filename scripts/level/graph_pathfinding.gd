extends Node

signal finish_pathFinfing(r : Array)

var start_room: Room
var finish_room: Room

var rooms: Array
var path: Array


func clear():
	start_room = null
	finish_room = null
	rooms.clear()
	path.clear()



func get_farthest_room() -> Room:
	if not start_room:
		return null

	var farthest: Room = null
	var max_depth: int = 0

	var queue: Array = [[start_room, 0]]
	var visited: Array = []

	while queue.size() > 0:
		var current = queue.pop_front()
		var room: Room = current[0]
		var depth: int = current[1]

		if room in visited:
			continue
		visited.append(room)

		if depth > max_depth:
			max_depth = depth
			farthest = room

		
		for child in room.children:
			if child not in visited:
				queue.append([child, depth + 1])

		
		if room.parent and room.parent not in visited:
			queue.append([room.parent, depth + 1])

	return farthest



func find_path(current_room: Room, target: Room, visited: Array = []) -> Array:
	
	visited = visited.duplicate()
	visited.append(current_room)

	if current_room == target:
		return visited.duplicate()

	
	for child in current_room.children:
		if child in visited:
			continue
		var res = find_path(child, target, visited)
		if res.size() > 0:
			return res

	
	if current_room.parent and current_room.parent not in visited:
		var res = find_path(current_room.parent, target, visited)
		if res.size() > 0:
			return res

	return []




var depth_map : Dictionary = {}

func calculate_depths():
	depth_map.clear()
	var queue : Array = [[start_room,0]]
	var visited : Array = []
	while queue.size() >0:
		var current = queue.pop_front()
		var room : Room = current[0]
		var depth : int = current[1]

		if room in visited:
			continue
		visited.append(room)
		depth_map[room] = depth
		room.depth = depth
		for child in room.children:
			if child not in visited:
				queue.append([child,depth+1])








func build_finished(r: Array) -> void:
	clear()
	start_room = r[0]
	rooms = r
	finish_room = get_farthest_room()
	calculate_depths()
	if finish_room:
		path = find_path(start_room, finish_room)
		print("Path length: ", path.size())
		finish_pathFinfing.emit(rooms)
	else:
		push_error("Could not find a farthest room.")


func _process(_delta: float) -> void:
	if path and path.size() > 1:
		for i in range(path.size() - 1):
			var from = path[i].global_position
			var to = path[i + 1].global_position
			DebugDraw3D.draw_arrow(from + Vector3.UP, to+ Vector3.UP, Color.RED,0.1)
