extends Node

class_name StateMachine

@onready var player : Player = self.get_parent()


var current_state : State



func change_state(new: State) -> void:
    if current_state != null:
        current_state.exit()
    current_state = new
    current_state.start()

func _process(delta: float) -> void:
    if current_state:
        current_state.update(delta)

func _physics_process(delta: float) -> void:
    if current_state:
        current_state.pyhsics_update(delta)