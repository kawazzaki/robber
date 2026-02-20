extends StaticBody3D



class_name Room




@export var room_size : Vector2
@export var can_rotate : bool
@export var links : Node3D

var doors = []


var parent : Room
var children : Array[Room]

var depth: int = 0
var room_type: String = "normal"
var puzzle : Dictionary
# each puzzle:
# {
#   "id": "puzzle_0",
#   "problem_room": Room,  <- the lock/puzzle is here
#   "solution_room": Room, <- the item/solution is here
#   "solved": false
# }


func clear():
	parent = null
	children.clear()
	doors.clear()

func build():
	set_doors_direction()




func set_doors_direction():
	doors.clear()
	for l : Node3D in links.get_children():
		var door_forward = -l.global_transform.basis.z.normalized()
		doors.append({
			"obj":l,
			"dir":door_forward,
			"to_center":self.global_position - l.global_position
		})

func get_door_by_dir(dir : Vector3):
	for door in doors:
		if dir.is_equal_approx(door["dir"]):
			return door
	return null



func _ready() -> void:
	DebugConsole.add_command("br",build,self)



func _process(delta: float) -> void:
	DebugDraw3D.draw_text(self.global_position + Vector3.UP * 2 , "depth : " + str(depth) ,144,Color.WHITE)
	if puzzle:
		if puzzle["problem_room"] == self:
			DebugDraw3D.draw_text(self.global_position + Vector3.UP * 3 + Vector3.FORWARD , "problem : " + str(puzzle["id"] ) ,124,Color.GREEN_YELLOW)
		else:
			DebugDraw3D.draw_text(self.global_position + Vector3.UP * 3 + Vector3.FORWARD , "solution : " + str(puzzle["id"]) ,124,Color.GREEN_YELLOW)
		
	if doors.is_empty():return
	for door in doors:
		DebugDraw3D.draw_arrow(door["obj"].global_position,door["obj"].global_position + door["dir"]*0.7, Color.BLUE,0.1)
