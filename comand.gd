extends LineEdit

const commands = ["start", "stop", "maxplayers", "playerlist", "gamelist", "kick", "ban", "banip", "stopgame", "help"]
@onready var console = get_node("../console")

func _ready():
	grab_focus()

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("command"):
		if text == "": grab_focus()
		else:
			process_input(text)
			clear()

func process_input(input : String):
	var args = input.split(" ")
	
	if commands.has(args[0]):
		run_cmd(args)
	
	else:
		console.push(input, "none")
		
func run_cmd(cmd : Array):
	match cmd[0]:
		"help":
			console.push("List of avalable commands:", "info")
			for command in commands:
				console.push("   "+command, "info")
		
		"maxplayers":
			if cmd.size() > 1 and typeof(int(cmd[1])) == TYPE_INT and int(cmd[1]) > 0:
				get_parent().max_players = int(cmd[1])
				console.push("max players set to " + str(get_parent().max_players), "none")
			
			elif cmd.size() == 1: console.push("max players is currently " + str(get_parent().max_players), "none")
			else: console.push("Invalid arguments", "alert")
		
		"start":
			get_parent().create_server()
