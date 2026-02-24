extends Node

@export var door_scene : PackedScene

func spawn_door(info : Array,index : int , rng : RandomNumberGenerator):
    var door : StaticBody3D = door_scene.instantiate()
    var room : Room = info[0]
    var door_info : Dictionary = info[1]

    # dir is already in world space (stored after room.build() which accounts for scale)
    var dir : Vector3 = -door_info["dir"]
    var angle = atan2(dir.x, dir.z)

    # Add door to the scene root (not the room) so it's not affected by room scale
    room.get_node("links").add_child(door)
    door.global_rotation.y = angle
    door.open_side = 1 if dir.x > 0 else -1 
    door.global_position = room.global_position - door_info["to_center"] + door_info["dir"] * 0.3 - door.transform.basis.x

    door.name = "door"+str(index)

func build_finished(c: Array , rng:RandomNumberGenerator) -> void:
    for i in c.size():
        spawn_door(c[i],i,rng)



