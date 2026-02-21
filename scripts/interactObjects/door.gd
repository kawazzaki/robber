extends InteractableObject

var is_opened = false
var original_rotation : Vector3
@export var open_speed : float = 0.4
@export var center : Node3D

func _ready() -> void:
	original_rotation = rotation_degrees

func interact(player: Player) -> void:
	var direction = (player.global_position - center.global_position).normalized()
	var dot = direction.dot(center.transform.basis.z)
	var new_rotation = original_rotation
	if is_opened:
		new_rotation = original_rotation 
		is_opened = false
	else:
		
		if dot>0 :
			new_rotation += Vector3.UP * 90
		else:
			new_rotation -=  Vector3.UP * 90
		is_opened = true
		
	var tween = create_tween()
	tween.tween_property(self,"rotation_degrees",new_rotation,0.2)

	




func interact_update():
	DebugDraw3D.draw_line(center.global_position,center.global_position - transform.basis.z)
	DebugDraw3D.draw_text(center.global_position - transform.basis.z , str(rotation_degrees))