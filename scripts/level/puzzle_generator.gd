extends Node


var puzzles: Array = []

# each puzzle:
# {
#   "id": "puzzle_0",
#   "problem_room": Room,  <- the lock/puzzle is here
#   "solution_room": Room, <- the item/solution is here
#   "solved": false
# }


@export var graph : Node

var rng = RandomNumberGenerator.new()

func generate(rooms : Array):

	var shallow_rooms = []
	var deep_rooms = []

	var max_depth = 0

	for room : Room in rooms:
		if room.depth > max_depth:
			max_depth = room.depth
	var half = max_depth/2

	for  room : Room in rooms:
		if room.depth <= half:
			shallow_rooms.append(room)
		else:
			deep_rooms.append(room)
	
	var puzzle_count = clamp(rooms.size()/4,1,5)

	for i in range(puzzle_count):
		if shallow_rooms.is_empty() or deep_rooms.is_empty():
			break

		var solution_room : Room = shallow_rooms.pick_random()
		shallow_rooms.erase(solution_room)

		var problem_room : Room = deep_rooms.pick_random()
		deep_rooms.erase(problem_room)


		var id = "puzzle_%d" %i
		#solution_room.puzzle_id = id
		#problem_room.puzzle_id = id
		var puzzle = {
			"id": id,
			"problem_room": problem_room,
			"solution_room": solution_room,
			"solved": false
		}
		solution_room.puzzle = puzzle
		problem_room.puzzle = puzzle
		puzzles.append(puzzle)

		print("Puzzle %s → item in depth %d, lock in depth %d" % [id, solution_room.depth, problem_room.depth])



func solve(id: String):
	for puzzle in puzzles:
		if puzzle["id"] == id:
			puzzle["solved"] = true
			print("Solved: " + id)

#func _on_graph_pathfinding_finish_path_finfing(r: Array) -> void:
#	generate(r)
