extends Node

const port = 25565
var max_players = 128
var multiplayer_peer = ENetMultiplayerPeer.new()
Dictionary

var connected_player_ids = []

# [peer_id, [0], 0.0, "username",]
var player_queue = []

func _process(delta: float):
	for player in player_queue:
		player[2] += delta
	

func push(item, tag : String = "default"): $console.push(item, tag)

func create_server():
	push("Creating matching server...")
	multiplayer_peer.create_server(port, max_players)
	multiplayer.multiplayer_peer = multiplayer_peer
	push("Matching server created!")
	
	multiplayer_peer.peer_connected.connect(
		func(peer_id):
			push("New peer " + str(peer_id) + " connecting...")
			add_peer(peer_id)
	)
	
	multiplayer_peer.peer_disconnected.connect(func(peer_id): remove_peer(peer_id))
	
	
func add_peer(peer_id):
	connected_player_ids.append(peer_id)
	player_queue.append([peer_id, [0], 0.0])
	push("New peer " + str(peer_id) + " standby for ping")
	rpc_id(peer_id, "initial_ping")

func remove_peer(peer_id):
	connected_player_ids.remove_at(peer_id)
	player_queue.remove_at(get_queue_index(peer_id))
	push("Peer " + str(peer_id) + " disconnected")
	

func get_queue_index(peer_id):
	for player in player_queue:
		if player[0] == peer_id:
			return player_queue.find(player)


@rpc("reliable", "call_remote", "authority", 0)
func initial_ping():
	pass

@rpc("reliable", "call_remote", "any_peer", 0)
func recieve_ping(peer_id, modes : Array):
	var queue_index = get_queue_index(peer_id)
	player_queue[queue_index][1] = modes
	push("Peer " + str(peer_id) + " ping: " + str(round(player_queue[queue_index][2]*1000)))
	push("Peer " + str(peer_id) + " queue modes: " + str(player_queue[queue_index][1]))

@rpc("reliable", "call_remote", "authority", 0)
func join_game(port : int, mode : int):
	pass
