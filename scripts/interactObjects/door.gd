extends InteractableObject

var is_opened = false
var original_rotation : Vector3
@export var open_speed : float = 0.4

func _ready() -> void:
	original_rotation = rotation_degrees

func interact(player: Player) -> void:
	var player_dir = (player.global_position - global_position).normalized()
	var door_forward = transform.basis.z.normalized()
	var dot = player_dir.dot(door_forward)

	var tween = create_tween()
	if !is_opened:
		if dot > 0:
			tween.tween_property(self, "rotation_degrees", original_rotation + Vector3(0, -90, 0), open_speed)
		else:
			tween.tween_property(self, "rotation_degrees", original_rotation + Vector3(0, 90, 0), open_speed)
		is_opened = true
	else:
		# always return to original, no need to check dot
		tween.tween_property(self, "rotation_degrees", original_rotation, open_speed)
		is_opened = false

func interact_update():
	var pos = global_position + Vector3(1,1.5,0)
	DebugDraw3D.draw_line(pos,pos + global_basis.z ,Color.AQUA)
	pass
