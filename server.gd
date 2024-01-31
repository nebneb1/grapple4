extends Node

const port = 25565
var max_players = 128
var multiplayer_peer = ENetMultiplayerPeer.new()

var connected_player_ids = []

# [peer_id, 0, 0.0]
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
		func(new_peer_id):
			push("New peer " + str(new_peer_id) + " connecting...")
			await get_tree().create_timer(1.0).timeout
			add_peer(new_peer_id)
	)
	
	
func add_peer(peer_id):
	connected_player_ids.append(peer_id)
	player_queue.append([peer_id, [0], 0.0])
	push("New peer " + str(peer_id) + " connected successfully")
	


