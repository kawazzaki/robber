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

func _ready() -> void:
	original_rotation = rotation_degrees
	add_borders()



func interact(player: Player) -> void:
	if has_borders:return
	if player.interact_system.requirement == condition : isLocked = false
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


func add_borders():
	var spacing = 0.7  
	
	borders_count = randi_range(1,3)

	var total_height = (borders_count - 1) * spacing
	var start_y = total_height / 2.0

	for i in range(borders_count):
		var border: StaticBody3D = border_scene.instantiate()
		center.add_child(border)

		
		var y_pos = start_y - i * spacing + randf_range(-0.05, 0.05)
		var x_jitter = randf_range(-0.02, 0.02)  # slight horizontal drift

		border.position -= center.transform.basis.z * border_offset
		border.position += Vector3(x_jitter, y_pos, 0)

		var tilt = randf_range(-12, 12)
		border.rotation_degrees.z = tilt

		borders.append(border)
	

	if borders.is_empty(): return

	for border in borders:
		border.border_removed.connect(remove_border)


func remove_border(b):
	if !has_borders:return
	b.queue_free()
	borders_count -= 1
	borders.erase(b)
	if borders.is_empty():
		has_borders = false


func _process(delta: float) -> void:
	DebugDraw3D.draw_line(center.global_position,center.global_position - center.global_basis.z,Color.WHITE_SMOKE)
	DebugDraw3D.draw_text(center.global_position - center.global_basis.z,str(has_borders))
