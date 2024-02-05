extends Node

const team_colors = [Color(1, 0.5,0), Color(0, 0.5, 1)]

#var regen : Node
var proxy: Node2D
var username = "player"
var main: Node2D
var team = 0

var color : Color = Color(0,0,0)
var ball : RigidBody2D
var scoreboard : RichTextLabel

var ball_speed: int = 0
#func reset():
	#await get_tree().create_timer(0.0001).timeout
	#winner = ""
	#active = false
	#time = max_time
	#countdown = 5.0
#
#func _ready():
	#if PRACTICE_MODE: time = 999999999
	#var max_time = time
	#countdown = 5.0
#	for player in players:
#		player.disabled = true
	#await get_tree().create_timer(0.001).timeout
#
#func _process(delta):
	#if ball != null:
		#if time <= 0:
			#time = 0
			#ball.disable = true
			#for player in players: player[1].disabled = true
			#if scores[0] > scores[1]:
				#winner = "[center][color=#"+ str(team_colors[1].to_html()) +"]Blue Wins!"
				#main.get_node("transitionout").modulate = team_colors[1].to_html()
			#elif scores[1] > scores[0]:
				#winner = "[center][color=#"+ str(team_colors[0].to_html()) +"]Orange Wins!"
				#main.get_node("transitionout").modulate = team_colors[0].to_html()
			#else:
				#winner = "[center]DRAW!\nthis really should have a match point system but i havnt programed that yet lol"
				#
			#main.get_node("transitionout").emitting = true
			#await get_tree().create_timer(3.0).timeout
			#players = []	
			#scores = [0, 0]
			#get_tree().reload_current_scene()
			#reset()
		#
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
#
#var pause = false
#func _input(event):
	#if event.is_action_pressed("debug"):
		#if not pause: Engine.time_scale = 0
		#else: Engine.time_scale = 1
		#pause = not pause
	
