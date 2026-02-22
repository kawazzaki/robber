extends Node

class_name Multi

var peer = ENetMultiplayerPeer.new()
var port = 6002

@export var player_scene : PackedScene
@export var player_spawner : Node3D

func _ready() -> void:
	DebugConsole.add_command("host", host_server, self)
	DebugConsole.add_command("join", join_server, self)


func host_server():
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_peer_connected)
	add_player(multiplayer.get_unique_id())


func join_server():
	peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = peer

func _peer_connected(id: int):
	DebugConsole.log("player " + str(id) + " joined the party")
	add_player.rpc(id)
	
	# tell new player about existing players
	for existing_player in player_spawner.get_children():
		add_player.rpc_id(id, int(existing_player.name))

@rpc("authority", "call_local", "reliable")
func add_player(id: int):
	var player = player_scene.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)  
	player_spawner.add_child(player)
