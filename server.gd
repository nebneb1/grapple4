extends Node

const TIME_PER_GAME = 180.0
const ROUTING_PORT = 10000
const SEPERATION_DIST = Vector2(6000, 3000)

var open_ports = []
var max_players = 128
var multiplayer_peer = ENetMultiplayerPeer.new()

const max_players_per_game : Dictionary = {0:99999, 1:2, 2:4, 3:6}

var connected_player_ids = []

# [peer_id, [0], 0.0, "username"]
var player_queue = []
# [game_port, max_players, mode, [[[player1peerid, player1user], player2], [player3, player4]], [scoreOrange, scoreBlue], time_left]
var active_games = []
@onready var game = preload("res://main_server.tscn")

func _ready():
	Global.main_server = self
	for i in range(128):
		open_ports.append(true)

func _process(delta: float):
	var mode_counts = [0,0,0,0]
	for player in player_queue:
		player[2] += delta
		for modes in player[1]:
			mode_counts[modes] += 1
			if mode_counts[modes] >= max_players_per_game[modes]:
				push("Enough players connected in " + str(modes) + ", creating game!")
				create_game(modes)
	
func create_game(mode : int):
	var open_port = ROUTING_PORT
	for port in open_ports:
		open_port += 1
		if port: 
			open_ports[open_port-1-ROUTING_PORT] = false
			break
	
	if open_port == ROUTING_PORT:
		push("No open ports, unable to create match", "alert")
		return
		
	push("fetching players...")
	var players = []
	
	# janky line that shouldnt work but fixes a dum bug with the dum for loop for some dum reason
	player_queue.append(["",[0], 0.0])
	
	push(player_queue)
	for player in player_queue:
		if mode in player[1]:
			players.append(player)
			#player_queue.erase(player)
	
	# undo jank
	player_queue.erase(["",[0], 0.0])
	
	push(players)
	
	push("creating teams...")
	var teams = [[],[]]
	for i in range(mode):
		var plr = players.pick_random()
		# [peer_id, username, ready, filled]
		teams[0].append([plr[0], plr[3], false, false])
		players.erase(plr)
		
	for plr in players:
		teams[1].append([plr[0], plr[3], false, false])
		players.erase(plr)
	
	var info = [open_port, max_players_per_game[mode], mode, teams, [0, 0], TIME_PER_GAME]
	active_games.append(info)
	push(teams)
	
	push("Creating game instance on port " + str(open_port))
	var game_instance = game.instantiate()
	var game_num = open_port-ROUTING_PORT-1
	#seperates from other games
	game_instance.global_position = Vector2((game_num%8)*SEPERATION_DIST.x, (game_num/8)*-SEPERATION_DIST.y)
	game_instance.game_info = info
	$Games.add_child(game_instance)
	
	push("Telling players to join port " + str(open_port) + " in mode " + str(mode))
	for team in teams:
		for player in team:
			rpc_id(player[0], "join_game", open_port, mode)
	
	push(info)
	push("game created!")

func push(item, tag : String = "default"): $console.push(item, tag)

func create_server():
	push("Creating matching server...")
	multiplayer_peer.create_server(ROUTING_PORT, max_players)
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
	player_queue.append([peer_id, [0], 0.0, "player"])
	push("New peer " + str(peer_id) + " standby for ping")
	rpc_id(peer_id, "initial_ping")

func remove_peer(peer_id):
	connected_player_ids.erase(peer_id)
	if player_queue.size() != 0:
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
func recieve_ping(peer_id, modes : Array, user : String):
	var queue_index = get_queue_index(peer_id)
	player_queue[queue_index][1] = modes
	player_queue[queue_index][3] = user
	push("Peer " + str(peer_id) + " username set: \"" + user + "\"")
	push(user + " ping: " + str(round(player_queue[queue_index][2]*1000)))
	push(user + " queue modes: " + str(player_queue[queue_index][1]))

@rpc("reliable", "call_remote", "authority", 0)
func join_game(port : int, mode : int):
	pass
