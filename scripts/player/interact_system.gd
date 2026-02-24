extends Node

@onready var player : Player = self.get_parent()

var requirement : String 

func _ready() -> void:
    DebugConsole.add_command(
        "set_req",
        set_requirement,
        self,
        [DebugCommand.Parameter.new("requirement", DebugCommand.ParameterType.String)],
    )

func set_requirement(value: String) -> void:
    requirement = value

func _process(delta: float) -> void:
    if multiplayer.has_multiplayer_peer():if !is_multiplayer_authority():return
    if Input.is_action_just_pressed("interact") and player.aim_raycast:
        if player.aim_raycast.current_interactable:
            player.aim_raycast.current_interactable.interact(player)