extends StaticBody3D



class_name Room




@export var room_size : Vector2
@export var can_rotate : bool
@export var links : Node

var doors = []

func build():

    pass


func set_doors_direction():
    for l : Node3D in links:
        var door_forward = -l.global_transform.basis.z.normalized()
        doors.append({
            "obj":l
        })
    pass