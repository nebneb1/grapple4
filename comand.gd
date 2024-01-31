extends LineEdit

const commands = ["start", "stop", "maxplayers", "plist", "qlist", "gamelist", "kick", "ban", "banip", "stopgame", "help"]
@onready var console = get_node("../console")
var server_started : bool = false

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

func push(item, tag : String = "default"): console.push(item, tag)

func process_input(input : String):
	var args = input.split(" ")
	
	if commands.has(args[0]):
		run_cmd(args)
	
	else:
		push(input, "none")

func invalid_arguments(): push("Invalid arguments", "alert")
func run_cmd(cmd : Array):
	match cmd[0]:
		"help":
			push("List of avalable commands:", "info")
			for command in commands:
				push("   "+command, "info")
		
		"maxplayers":
			if cmd.size() > 1 and typeof(int(cmd[1])) == TYPE_INT and int(cmd[1]) > 0:
				get_parent().max_players = int(cmd[1])
				push("max players set to " + str(get_parent().max_players), "none")
			
			elif cmd.size() == 1: push("max players is currently " + str(get_parent().max_players), "none")
			else: invalid_arguments()
		
		"start":
			get_parent().create_server()
			server_started = true
		
		"qlist":
			get_parent().rpc_id(get_parent().player_queue[0][0], "initial_ping")
			if !server_started: push("Server not started", "alert")
			elif get_parent().player_queue.size() == 0: push("No players connected", "alert")
			
			for player in get_parent().player_queue:
				push(str(player[0]) + " queuing " + str(player[1]) + " waiting " + str(player[2]) + "s", "none")
