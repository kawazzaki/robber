extends Node

class_name StateMachine




@onready var player_controller : Player = self.get_parent()

var current_state : State
var prev_state : State

func change_state(next_state):
	if current_state == next_state:
		return
	
	if current_state != null:
		current_state.exit()
	
	prev_state = current_state
	current_state = next_state
	current_state.enter()


func _process(delta: float) -> void:
	if current_state:
		current_state.update()
	


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update()
