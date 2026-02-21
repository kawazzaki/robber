extends InteractableObject

@export var isLocked = true

var is_opened = false
var original_rotation : Vector3
@export var open_speed : float = 0.4
@export var center : Node3D

func _ready() -> void:
	original_rotation = rotation_degrees



func interact(player: Player) -> void:
	if player.interact_system.requirement == "key": isLocked = false
	if isLocked:return
	var new_rotation : Vector3
	if !is_opened:
		new_rotation = original_rotation + Vector3(0,-90,0)
		is_opened = true
	else:
		new_rotation = original_rotation 
		is_opened = false
	var t = create_tween()
	t.tween_property(self,"rotation_degrees",new_rotation,0.2)




func _process(delta: float) -> void:
	DebugDraw3D.draw_line(center.global_position,center.global_position - center.global_basis.z,Color.WHITE_SMOKE)
