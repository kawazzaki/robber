extends Node


var start_room : Room
var finish_room : Room

var rooms = [] 

func get_farthest_room(start_room: Room) -> Room:
    var visited = {}
    var farthest_room: Room = start_room
    var max_depth := -1

    # stack = array من tuples (room, depth)
    var stack = [(start_room, 0)]
    
    while stack.size() > 0:
        var item = stack.pop_back()
        var room = item[0]
        var depth = item[1]
        
        if room in visited:
            continue
        visited[room] = true
        
        if depth > max_depth:
            max_depth = depth
            farthest_room = room
        
        # push children
        for child in room.children:
            if child not in visited:
                stack.append((child, depth + 1))
        
        # push parent if exists
        if room.parent and room.parent not in visited:
            stack.append((room.parent, depth + 1))
    
    return farthest_room


func _on_finish_build(ROOMS: Array) -> void:
	pass # Replace with function body.
