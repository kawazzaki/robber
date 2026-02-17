extends Node


class_name State


var player_controller : Player
var state_machine : StateMachine

func _ready():
    state_machine = self.get_parent()
    player_controller = state_machine.get_parent()



func enter():pass

func exit():pass

func update():pass

func physics_update():pass