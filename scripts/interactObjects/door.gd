extends RequirementInteractable



var original_rotation : Vector3
var initialized : bool = false

@export var is_open : bool = false
@export var open_side: int = 1

@export var isLocked : bool = false


func _ready() -> void:
	# Defer so add_doors.gd has time to set global_rotation before we capture it
	call_deferred("_capture_rotation")


func _capture_rotation() -> void:
	original_rotation = rotation
	initialized = true


func interact(player : Player):
	super.interact(player)
	if verify_condition(player): isLocked = false
	if isLocked: return
	if not initialized: return

	# Determine which side the player is on relative to the door's forward axis
	var local_dir = to_local(player.global_position)
	var side = 1 if local_dir.dot(-transform.basis.z) > 0 else -1

	interact_rpc.rpc(side)


@rpc("any_peer", "call_local", "reliable")
func interact_rpc(side: int):
	open_side = side  # sync open direction to all peers
	toggle_door()


func toggle_door() -> void:
	var tween = create_tween()
	if is_open:
		tween.tween_property(self, "rotation", original_rotation, 0.1)
		is_open = false
	else:
		tween.tween_property(self, "rotation", original_rotation + Vector3(0, (PI / 2) * open_side, 0), 0.1)
		is_open = true


func _process(delta: float) -> void:
	DebugDraw3D.draw_line(global_position, global_position - transform.basis.z, Color.AZURE)
	DebugDraw3D.draw_text(global_position - transform.basis.z * 0.5 + Vector3.UP * 1.5 + transform.basis.x, str(original_rotation))
	DebugDraw3D.draw_text(global_position - transform.basis.z * 0.5 + Vector3.UP * 2.5 + transform.basis.x, str(condtion_name), 32, Color.WHEAT)
	DebugDraw3D.draw_text(global_position - transform.basis.z * 0.5 + Vector3.UP * 2 + transform.basis.x, "L: " + str(isLocked), 32, Color.BISQUE)