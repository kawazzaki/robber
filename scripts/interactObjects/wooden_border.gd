extends InteractableObject


signal border_removed(border : InteractableObject)

@export var condition: String

#func interact(player : Player):
#    if player.interact_system.requirement != condition : return
#    border_removed.emit(self)
#    pass


