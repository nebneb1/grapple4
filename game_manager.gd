extends Node2D

const team_colors = [Color(1, 0.5,0), Color(0, 0.5, 1)]

#multi
var authority_id
var id
var team = 0

#var regen : Node
var main: Node2D
var color : Color = Color(0,0,0)
var ball : RigidBody2D
var scoreboard : RichTextLabel
var scores := [0, 0]
var players = []
var countdown: float = -1.0

# big game changes
var SCALE = 2.0
var GRAVITY: bool = true
var SOCCAR_MODE: bool = false
var PADDLE_BALL: bool = true
var time := 180.0

#soccar settings:
const hit_buffer := 30
const hit_power := 5.0
const NEAR_DAMP := 1.5
const DAMP_FALLOFF := 0.3
const BASE_DAMP := 0.00
const KICK_DELAY := 1.0

var max_time := 180.0
var winner = ""
var active := false


var ball_speed: int = 0

var game_info = [10000, 2, 1, [[],[]], [0, 0], 0.0]
@onready var puppet_player_scene := preload("res://puppet_client_player.tscn")
@onready var player_scene := preload("res://client_player.tscn")
@onready var menu := preload("res://menu.tscn")

func reset():
	await get_tree().create_timer(0.0001).timeout
	winner = ""
	active = false
	time = max_time
	countdown = 5.0

func _ready():
	#Global.node = self
	GlobalClient.proxy = self
	var max_time = time
	countdown = 5.0
#	for player in players:
#		player.disabled = true
	get_node("transition").modulate = color
	get_tree().paused = true
	$transition.emitting = true
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	await get_tree().create_timer(0.001).timeout


@rpc("authority", "call_remote", "reliable")
func end_game(winner_orange : bool):
	
	get_tree().change_scene_to_packed(menu)

#func _process(delta):
		#if countdown <= 0 and countdown > -1:
			#countdown = -1
			#for player in players:
				#player[1].disabled = false
			#if GRAVITY:
				#ball.gravity_scale = 1.0/SCALE
				#ball.apply_impulse(Vector2(0, -1.2/pow(SCALE, 0.5)), Vector2.ZERO)
			#active = true
		#elif countdown > -1: 
			#active = false
			#countdown -= delta
			#for player in players:
				#if is_instance_valid(player[1]):
					#player[1].disabled = true
			#ball.gravity_scale = 0
			#if GRAVITY:
				#ball.position = Vector2(1920, 1620)
			#else:
				#ball.position = Vector2(1920, 1080)
			#ball.linear_velocity = Vector2.ZERO
		#if active: time -= delta

func get_peer_info(peer):
	var plrs = game_info[3][0]
	plrs.append_array(game_info[3][1])
	for plr in plrs:
		if plr[0] == peer:
			return plr
	
@rpc("reliable", "call_remote", "authority")
func client_sync(sca,gra,soc,pad,p_id, a_id):
	SCALE = sca
	GRAVITY = gra
	SOCCAR_MODE = soc
	PADDLE_BALL = pad
	authority_id = a_id
	id = p_id
	print(authority_id, " a ", id)
	rpc_id(authority_id, "server_sync", id, GlobalClient.username)

@rpc("reliable", "call_remote", "any_peer")
func server_sync(peer_id, username): pass

@rpc("reliable", "call_remote", "authority")
func info_sync(info): 
	game_info = info

@rpc("reliable", "call_remote", "authority")
func spawn_sync(positions : Array):
	for player in positions:
		if player[0] == id:
			pass
		var info = get_peer_info(player[0])
		var player_instance = puppet_player_scene.instantiate()
		player_instance.global_position

@rpc("reliable", "call_remote", "authority")
func set_team(team_ : int):
	GlobalClient.team = team_
	team = team_
