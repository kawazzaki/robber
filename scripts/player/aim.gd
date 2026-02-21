
extends RayCast3D

var current_interactable: InteractableObject = null


func _physics_process(delta: float) -> void:
    force_raycast_update()
    update_interaction()



func update_interaction():

    if is_colliding():
        var collider = get_collider()

        
        if collider is InteractableObject:
            if current_interactable != collider:
                # Exit 
                if current_interactable != null:
                    current_interactable.interact_exit()

                # Start
                current_interactable = collider
                current_interactable.interact_start()
            else:
                # Same object, keep updating
                current_interactable.interact_update()
        else:
            # Hit something but not interactable
            _clear_interactable()
    else:
        # Not hitting anything
        _clear_interactable()


func _clear_interactable():
    if current_interactable != null:
        current_interactable.interact_exit()
        current_interactable = null