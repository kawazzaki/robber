extends StaticBody3D

class_name Room

@export var room_size : Vector2
@export var can_rotate : bool
@export var links : Node3D

var doors = []
var parent : Room
var children : Array[Room]
var depth: int = 0
<<<<<<< HEAD

@export var room_type: String
=======
var room_type: String = "normal"
>>>>>>> parent of 8cfbc30 (d5.0)
var puzzle : Dictionary

func clear():
	parent = null
	children.clear()
	doors.clear()

func build(rng : RandomNumberGenerator):
	# rng is the single shared instance from Level
	set_doors_direction()

func set_doors_direction():
	doors.clear()
	for l : Node3D in links.get_children():
		var door_forward = -l.global_transform.basis.z.normalized()
		doors.append({
			"obj": l,
			"dir": door_forward,
			"to_center": self.global_position - l.global_position
		})

<<<<<<< HEAD
func get_door_by_dir(dir: Vector3, rng: RandomNumberGenerator) -> Dictionary:
	var matches = []
	for door in doors:
		if dir.is_equal_approx(door["dir"]):
			matches.append(door)
	if matches.is_empty():
		return {}
	return matches[rng.randi_range(0, matches.size() - 1)]
=======
func get_door_by_dir(dir : Vector3):
	for door in doors:
		if dir.is_equal_approx(door["dir"]):
			return door
	return null


>>>>>>> parent of 8cfbc30 (d5.0)

func _ready() -> void:
	DebugConsole.add_command("br", func(): build(RandomNumberGenerator.new()), self)

func _process(_delta: float) -> void:
	DebugDraw3D.draw_text(self.global_position + Vector3.UP * 2, "depth : " + str(depth), 144, Color.WHITE)
	DebugDraw3D.draw_text(self.global_position + Vector3.UP * 1, str(name), 144, Color.WHITE)
	if puzzle:
		if puzzle["problem_room"] == self:
			DebugDraw3D.draw_text(self.global_position + Vector3.UP * 3 + Vector3.FORWARD, "problem : " + str(puzzle["id"]), 124, Color.GREEN_YELLOW)
		else:
			DebugDraw3D.draw_text(self.global_position + Vector3.UP * 3 + Vector3.FORWARD, "solution : " + str(puzzle["id"]), 124, Color.GREEN_YELLOW)
	if doors.is_empty(): return
	for door in doors:
		DebugDraw3D.draw_arrow(door["obj"].global_position, door["obj"].global_position + door["dir"] * 0.7, Color.BLUE, 0.1)