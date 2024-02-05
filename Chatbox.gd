extends VBoxContainer
var focused = false
var team = 0

const WINDOW_VISIBILITY_TIME = 5.0

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
				print(chatbar.text, GlobalClient.username, GlobalClient.team)
				$Chatbar.text = ""
				chatbar.release_focus()
				focused = false
			else:
				chatbar.release_focus()
				focused = false
		
		else:
			focused = true
			reset_visibility(true)
			chatbar.text = ""
			chatbar.grab_focus()

func _process(delta: float) -> void:
	if visibility_timer > 0 and not hold_visibility: visibility_timer -= delta
	elif visibility_timer <= 0: visibility_timer = 0
	
	if focused: 
		chatbar.grab_focus()
		
	get_parent().modulate.a = clamp(visibility_timer, 0.0, 1.0)
	



@rpc("any_peer", "call_local", "reliable")
func check_message(message : String, username : String, team : int): pass

@rpc("authority", "call_local", "reliable")
func recieve_message(message : String):
	reset_visibility(false)
	chathist.text = chathist.text + message 
