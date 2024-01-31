extends Control

var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 25565
const ADDRESS = "127.0.0.1"

func _on_button_pressed() -> void:
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	

	
