extends Node


@export var head: Node3D

@onready var player: Player = head.get_parent()

func _process(delta: float) -> void:
	if head:
		DebugDraw3D.draw_line(
			head.global_position,
			head.global_position + head.global_transform.basis.z * -1,
			Color.RED
		)
	if player:
		imgui_wind()


func imgui_wind():
	ImGui.Begin("player_controller :")
	if player.state_machine.current_state != null:
		ImGui.Text("player current state is : " + str(player.state_machine.current_state.name))
		if player.is_crouching:
			ImGui.SameLine()
			ImGui.TextColored(Color.SEA_GREEN,"crouch state is :" + str(player.crouch.crouch_state) )
			pass

	ImGui.Text("player current speed is : " + str(player.move_speed))
	ImGui.Text("crouching :" + str(player.is_crouching) + "    spriting:" + str(player.is_sprinting))
	ImGui.Text("move velocity : " + str(player.velocity))
	if player.is_crouching:
		ImGui.TextColored(Color.GREEN,"can stand :" + str(player.crouch.can_stand()))

	ImGui.Text("aiming at :" + str(player.get_node("interact").aiming()))
	ImGui.End()
	pass
