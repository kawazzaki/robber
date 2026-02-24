extends InteractableObject

class_name RequirementInteractable


@export var condtion_name : String


func interact(player : Player):
    super.interact(player)
    pass



func verify_condition(player : Player):
    if player.interact_system.requirement == condtion_name:
        return true
    return false
