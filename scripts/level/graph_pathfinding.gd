extends Node


var start_room: Room
var finish_room: Room

var rooms: Array
var path: Array


func clear():
	start_room = null
	finish_room = null
	rooms.clear()
	path.clear()


# BFS to find the room with the most hops from start_room
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

		# Traverse children
		for child in room.children:
			if child not in visited:
				queue.append([child, depth + 1])

		# Traverse parent
		if room.parent and room.parent not in visited:
			queue.append([room.parent, depth + 1])

	print("Farthest room: ", farthest, " at depth ", max_depth)
	return farthest


# DFS path finding using the actual parent/children graph
func find_path(current_room: Room, target: Room, visited: Array = []) -> Array:
	# Clone visited to avoid sharing state across recursive branches
	visited = visited.duplicate()
	visited.append(current_room)

	if current_room == target:
		return visited.duplicate()

	# Walk forward into children
	for child in current_room.children:
		if child in visited:
			continue
		var res = find_path(child, target, visited)
		if res.size() > 0:
			return res

	# Walk backward to parent
	if current_room.parent and current_room.parent not in visited:
		var res = find_path(current_room.parent, target, visited)
		if res.size() > 0:
			return res

	return []


func build_finished(r: Array) -> void:
	clear()
	start_room = r[0]
	rooms = r
	finish_room = get_farthest_room()

	if finish_room:
		path = find_path(start_room, finish_room)
		print("Path length: ", path.size())
	else:
		push_error("Could not find a farthest room.")


func _process(_delta: float) -> void:
	if path and path.size() > 1:
		for i in range(path.size() - 1):
			var from = path[i].global_position
			var to = path[i + 1].global_position
			DebugDraw3D.draw_arrow(from + Vector3.UP, to+ Vector3.UP, Color.RED,0.1)
