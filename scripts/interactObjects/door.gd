extends RequirementInteractable



var original_rotation : Vector3
var open_rotation : Vector3

var is_open : bool =false

var open_side: int = 1 
var initialized: bool = false


@export var isLocked : bool = false

func _ready() -> void:
	original_rotation = rotation
	open_rotation = original_rotation + Vector3(0,-PI/2,0)


func interact(player : Player):
	super.interact(player)
	if verify_condition(player):isLocked = false
	if isLocked:return
	interact_rpc.rpc()

@rpc("any_peer","call_local","reliable")
func interact_rpc():
	toggle_door()


func toggle_door() -> void:
	if not initialized:
		original_rotation = rotation
		initialized = true

	var tween = create_tween()
	if is_open:
		tween.tween_property(self, "rotation", original_rotation, 0.1)
		is_open = false
	else:
		tween.tween_property(self, "rotation", original_rotation + Vector3(0, (PI/2) * open_side, 0), 0.1)
		is_open = true


func _process(delta: float) -> void:
	DebugDraw3D.draw_line(global_position,global_position - transform.basis.z, Color.AZURE)
	DebugDraw3D.draw_text(global_position - transform.basis.z * 0.5 + Vector3.UP * 1.5 + transform.basis.x, str(original_rotation))
	DebugDraw3D.draw_text(global_position - transform.basis.z * 0.5 + Vector3.UP * 2.5 + transform.basis.x, str(condtion_name),32,Color.WHEAT)
	DebugDraw3D.draw_text(global_position - transform.basis.z * 0.5 + Vector3.UP * 2 + transform.basis.x, "L: " +str(isLocked),32,Color.BISQUE)
