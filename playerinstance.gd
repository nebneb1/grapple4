extends Node

func _ready():
	name = str(get_multiplayer_authority())

@rpc("unreliable")
func remote_send_inputpkg(inputs : Array): pass

@rpc("authority", "call_local", "reliable", 1)
func display_message(messge : String): pass
