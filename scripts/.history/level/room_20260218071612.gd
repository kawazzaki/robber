extends StaticBody3D



class_name Room




@export var room_size : Vector2
@export var can_rotate : bool
@export var links : Node3D

var doors = []


func build():
	set_doors_direction()



func set_doors_direction():
	for l : Node3D in links:
		var door_forward = -l.global_transform.basis.z.normalized()
		doors.append({
			"obj":l,
			"dir":door_forward,
			"to_center":self.global_position - l.global_position
		})



func _ready() -> void:
	DebugConsole.add_command("build_room",build,self)



func _process(delta: float) -> void:
	if doors.is_empty():return
	for door in doors:
		DebugDraw3D.draw_arrow(door["obj"].global_position,door["obj"].global_position + door["dir"]*0.3, Color.BLUE,0.1)
