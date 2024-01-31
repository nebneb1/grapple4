extends Control

var queue_modes : Array = [1]

const ROUTING_PORT = 10000
var curr_port = ROUTING_PORT
const ADDRESS = "127.0.0.1"

func _on_button_pressed() -> void:
	var multiplayer_peer = ENetMultiplayerPeer.new()
	multiplayer_peer.create_client(ADDRESS, ROUTING_PORT)
	multiplayer.multiplayer_peer = multiplayer_peer

@rpc("reliable", "call_remote", "authority", 0)
func initial_ping():
	rpc("recieve_ping", multiplayer.get_unique_id(), queue_modes)

@rpc("reliable", "call_remote", "any_peer", 0)
func recieve_ping(peer_id, mode : Array):
	pass

@rpc("reliable", "call_remote", "authority", 0)
func join_game(port : int, mode : int):
	curr_port = port
	var multiplayer_peer = ENetMultiplayerPeer.new()
	multiplayer_peer.create_client(ADDRESS, curr_port)
	multiplayer.multiplayer_peer = multiplayer_peer
	#add code to create game
