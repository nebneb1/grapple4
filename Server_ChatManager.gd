extends Node

var bad_phrases = []
var censors = ["$", "!", "@", "#", "%", ]

func _ready() -> void:
	var file := FileAccess.open("res://badwords.txt", FileAccess.READ)
	var line := file.get_line()
	while line != "end":
		bad_phrases.append(line)
		line = file.get_line()
	file.close()

@rpc("any_peer", "call_local", "reliable")
func check_message(message : String, username : String, team : int): 
	for phrase in bad_phrases:
		if phrase in message:
			while message.find(phrase) != -1:
				var loc = message.find(phrase)
				var last = ""
				var chosen = ""
				for i in range(phrase.len()):
					chosen = censors.pick_random()
					while last == chosen: chosen = censors.pick_random()
					last = chosen
					if message[loc+i] != " ":
						message[loc+i] = chosen
	
	rpc("recieve_message", "<[color=" + Global.team_colors[team].to_html() + "]" + username + "[/color]> " + message + "\n")

@rpc("authority", "call_local", "reliable")
func recieve_message(message : String): pass
