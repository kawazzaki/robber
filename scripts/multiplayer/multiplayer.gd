extends Node

class_name Multi

var peer = ENetMultiplayerPeer.new()
var port = 6002

@export var player_scene : PackedScene
@export var player_spawner : Node3D
@export var multiplayer_spawner : MultiplayerSpawner
@export var level : Level
var seed : int


func _ready() -> void:
	DebugConsole.add_command("host", host_server, self)
	DebugConsole.add_command("join", join_server, self)
	
	multiplayer_spawner.spawn_path = player_spawner.get_path()
	multiplayer_spawner.spawn_function = _spawn_player


func _spawn_player(id: int) -> Node:
	var player = player_scene.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)
	return player


func host_server():
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_peer_connected)
	seed = randi()
	multiplayer_spawner.spawn(multiplayer.get_unique_id())
	generate_level()


func join_server():
	peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = peer


func _peer_connected(id: int):
	DebugConsole.log("player " + str(id) + " joined the party")
	multiplayer_spawner.spawn(id)
	generate_level.rpc_id(id, seed)


@rpc("authority", "reliable")
func generate_level(s: int = 0):
	if s != 0:
		seed = s
	level.build(seed)