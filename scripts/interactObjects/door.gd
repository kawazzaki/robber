extends InteractableObject

@export var isLocked = true
@export var has_borders = true
@export var open_speed : float = 0.4
@export var borders_count : int = 1
@export var border_offset : float
@export var condition : String

@export_category("components")
@export var center : Node3D
@export var border_scene : PackedScene

var original_rotation : Vector3
var is_opened = false
var borders = []

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.seed = Global.seed
	original_rotation = rotation_degrees
	if !has_borders: return
	add_borders()

func interact(player: Player) -> void:
	if has_borders: return
	if player.interact_system.requirement == condition: isLocked = false
	if isLocked: return

	if not multiplayer.is_server():
		request_toggle.rpc_id(1)
	else:
		_do_toggle()
		sync_door.rpc(is_opened)

@rpc("any_peer", "call_remote", "reliable")
func request_toggle():
	if not multiplayer.is_server(): return
	_do_toggle()
	sync_door.rpc(is_opened)

func _do_toggle():
	is_opened = !is_opened
	var new_rotation : Vector3
	if is_opened:
		new_rotation = original_rotation + Vector3(0, -90, 0)
	else:
		new_rotation = original_rotation
	var t = create_tween()
	t.tween_property(self, "rotation_degrees", new_rotation, 0.2)

@rpc("authority", "call_remote", "reliable")
func sync_door(opened: bool):
	is_opened = opened
	var new_rotation : Vector3
	if is_opened:
		new_rotation = original_rotation + Vector3(0, -90, 0)
	else:
		new_rotation = original_rotation
	var t = create_tween()
	t.tween_property(self, "rotation_degrees", new_rotation, 0.2)

func add_borders():
	var spacing = 0.7
	borders_count = rng.randi_range(1, 3)

	var total_height = (borders_count - 1) * spacing
	var start_y = total_height / 2.0

	for i in range(borders_count):
		var border: StaticBody3D = border_scene.instantiate()
		border.name = "Border_" + str(i)
		center.add_child(border)

		var y_pos = start_y - i * spacing + rng.randf_range(-0.05, 0.05)
		var x_jitter = rng.randf_range(-0.02, 0.02)

		border.position -= center.transform.basis.z * border_offset
		border.position += Vector3(x_jitter, y_pos, 0)
		border.rotation_degrees.z = rng.randf_range(-12, 12)

		borders.append(border)

	if borders.is_empty(): return

	for border in borders:
		border.border_removed.connect(_on_border_removed.bind(border.name))

func _on_border_removed(border_name: String):
	if not multiplayer.is_server():
		request_remove_border.rpc_id(1, border_name)
	else:
		_do_remove_border(border_name)
		sync_remove_border.rpc(border_name)

@rpc("any_peer", "call_remote", "reliable")
func request_remove_border(border_name: String):
	if not multiplayer.is_server(): return
	_do_remove_border(border_name)
	sync_remove_border.rpc(border_name)

@rpc("authority", "call_remote", "reliable")
func sync_remove_border(border_name: String):
	_do_remove_border(border_name)

func _do_remove_border(border_name: String):
	if not has_borders: return
	var border = center.get_node_or_null(border_name)
	if border == null: return
	borders.erase(border)
	border.queue_free()
	borders_count -= 1
	if borders.is_empty():
		has_borders = false

func _process(_delta: float) -> void:
	DebugDraw3D.draw_line(center.global_position, center.global_position - center.global_basis.z, Color.WHITE_SMOKE)
	DebugDraw3D.draw_text(center.global_position - center.global_basis.z, str(has_borders))