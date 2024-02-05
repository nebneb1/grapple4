extends VBoxContainer
var focused = false
var team = 0

const WINDOW_VISIBILITY_TIME = 7.0

var visibility := 1.0
var hold_visibility : bool = false
var visibility_timer := 0.0

@onready var chatbar : LineEdit = $Chatbar
@onready var chathist = $ChatHistory

func reset_visibility(stop : bool = false): 
	hold_visibility = stop
	visibility_timer = WINDOW_VISIBILITY_TIME


func _ready() -> void:
	$ChatHistory.text = ""
	team = GlobalClient.team

func _input(event: InputEvent):
	if event.is_action_pressed("command"):
		if focused:
			reset_visibility(false)
			if chatbar.text != "":
				rpc_id(GlobalClient.proxy.authority_id, "check_message", chatbar.text, GlobalClient.username, GlobalClient.team)
				$Chatbar.text = ""
				chatbar.release_focus()
				focused = false
			else:
				chatbar.release_focus()
				focused = false
		
		else:
			focused = true
			reset_visibility(false)
			chatbar.text = ""
			chatbar.grab_focus()

func _process(delta: float) -> void:
	if visibility_timer > 0 and not hold_visibility: visibility_timer -= delta
	else: visibility_timer = 0
	
	modulate.a = visibility_timer



@rpc("any_peer", "call_local", "reliable")
func check_message(message : String, username : String, team : int): pass

@rpc("authority", "call_local", "reliable")
func recieve_message(message : String):
	chathist.text = chathist.text + message 
