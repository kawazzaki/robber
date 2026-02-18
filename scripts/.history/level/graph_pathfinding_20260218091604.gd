extends Node


var start_room : Room
var finish_room : Room

func get_farthest_room(start_room):
    var visited = {}
    var farthest_room = start_room
    var max_depth = -1

    
    
    dfs(start_room, 0)
    return farthest_room

func dfs(room, depth):
        visited[room] = true
        if depth > max_depth:
            max_depth = depth
            farthest_room = room
        for child in room.children:
            if child in visited:
                continue
            dfs(child, depth + 1)
        # Optionally: check parent too if your tree is bidirectional
        if room.parent and not room.parent in visited:
            dfs(room.parent, depth + 1)

func _on_finish_build(rooms: Array) -> void:
	pass # Replace with function body.
