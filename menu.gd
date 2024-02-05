extends Control

var queue_modes : Array = [1]
var username = "player"

const ROUTING_PORT = 10000
var curr_port = ROUTING_PORT
const ADDRESS = "127.0.0.1"

@onready var main_scene := preload("res://main_client.tscn")

func _ready():
	$LineEdit.grab_focus()

func _input(event: InputEvent):
	if event.is_action_pressed("command"):
		if $LineEdit.text != "": username = $LineEdit.text
		var multiplayer_peer = ENetMultiplayerPeer.new()
		multiplayer_peer.create_client(ADDRESS, ROUTING_PORT)
		multiplayer.multiplayer_peer = multiplayer_peer

@rpc("reliable", "call_remote", "authority", 0)
func initial_ping():
	rpc("recieve_ping", multiplayer.get_unique_id(), queue_modes, username)

@rpc("reliable", "call_remote", "any_peer", 0)
func recieve_ping(peer_id, modes : Array, user : String):
	pass

@rpc("reliable", "call_remote", "authority", 0)
func join_game(port : int, mode : int):
	curr_port = port
	var multiplayer_peer = ENetMultiplayerPeer.new()
	multiplayer_peer.create_client(ADDRESS, curr_port)
	multiplayer.multiplayer_peer = multiplayer_peer
	Global.username = username
	get_tree().change_scene_to_packed(main_scene)
