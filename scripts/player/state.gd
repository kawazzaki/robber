extends Node


class_name State

@onready var state_machine : StateMachine = self.get_parent()
var player : Player


func _ready() -> void:
    if state_machine:
        player = state_machine.get_parent()


func start():print(name)
func exit():pass
func update(delta :float):pass
func pyhsics_update(delta:float):pass