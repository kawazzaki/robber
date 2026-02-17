extends Node

var last_aimed_object : interactOBJ= null



@onready var player : Player = get_parent()

var current_aimed_object  = null

func _process(delta: float) -> void:
	current_aimed_object = aiming()
	check_interact()


func check_interact():
	if Input.is_action_just_pressed("interact") and Global.is_captured and current_aimed_object and current_aimed_object is interactOBJ:
		current_aimed_object.interact(self.get_parent())

func aiming():
	var other = null
	
	if player.aim_raycast and player.aim_raycast.is_colliding():
		other = player.aim_raycast.get_collider()
	
	# إذا اللاعب ما يaimش على أي object
	if not other:
		if last_aimed_object and last_aimed_object.has_method("on_aim_exit"):
			last_aimed_object.on_aim_exit()
			last_aimed_object = null
		return null
	
	# إذا اللاعب يaim على object جديد
	if other is interactOBJ and other != last_aimed_object:
		if last_aimed_object and last_aimed_object.has_method("on_aim_exit"):
			last_aimed_object.on_aim_exit()
		
		if other.has_method("on_aim_enter"):
			other.on_aim_enter(self.get_parent())
		
		last_aimed_object = other
	
	return other
