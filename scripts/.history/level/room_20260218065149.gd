extends StaticBody3D



class_name room




@export var room_size : Vector2
@export var can_rotate : bool


func _ready() -> void:
	DebugConsole.add_command("test",test,self)


func test():
	print('work')
	pass
