extends KinematicBody2D

export var player_num := 0
export var id: int = 4
export var team: int = 0
export var has_paddle: bool = false

var max_speed_mult = 1.0
const max_speed := 8.0/Global.SCALE
const dash_regen_rate := 2.5
const max_dashes := 3
const dash_speed := 30.0*Global.SCALE/1.5
const ring_size := 400.0*0.85/Global.SCALE
const PULL_SPEED := 10.0*1.5
const MAX_HOOKTIME := 2.5

var dashes := 0
var hooked := false
var dash_timer = 0.0
var hook_timer = 0.0
var velocity := Vector2.ZERO
var colors = [Color("#87FFC0"), Color("#A399FF"), Color("#FFAAA1"), Color("#FFF2A8")]
var radius := 20.0/Global.SCALE*2
var accel := 20.0/Global.SCALE
var ACCEL := accel
var disabled := true

#special modes
var kick_delay := 0.0
onready var paddle = $paddle

#anims--
var circle_rotation := 0.0
const lines = 32.0



func _ready():
	disabled = true
	Global.players.append([player_num, self])
	if has_paddle and Global.PADDLE_BALL:
		paddle.id = id
		$paddle/CollisionShape2D/ColorRect.color = Global.team_colors[team]
#		$paddle/CollisionShape2D2/ColorRect.color = Global.team_colors[team]
	else:
		paddle.queue_free()

func _physics_process(delta):
	if kick_delay > 0:
		kick_delay -= delta
	if not disabled:
		dash_timer += delta
		if dash_timer >= dash_regen_rate:
			if dashes < max_dashes:
				dashes += 1
			dash_timer = 0.0
	
	
	var dir: Vector2
	if not disabled:
		if id == 4:
			dir.x = int(Input.is_action_pressed("right"))-int(Input.is_action_pressed("left"))
			dir.y = int(Input.is_action_pressed("down"))-int(Input.is_action_pressed("up"))
			velocity = lerp(velocity, dir.normalized()*max_speed, delta*accel)
		else:
			dir.x = Input.get_joy_axis(id, 0)
			dir.y = Input.get_joy_axis(id, 1)
			if dir.length() > 1.0:
				velocity = lerp(velocity, dir.normalized()*max_speed, delta*accel)
			else:
				velocity = lerp(velocity, dir*max_speed, delta*accel)
		
	accel = ACCEL
	if hooked: 
		accel = ACCEL*3
		Global.ball.linear_damp = Global.BASE_DAMP
	
	if global_position.distance_to(Global.ball.position) <= ring_size+Global.ball.radius and Global.SOCCAR_MODE:
		Global.ball.can_hit = true
	
	if hooked:
		Global.ball.gravity_scale = 0
		Global.ball.apply_central_impulse((global_position-Global.ball.global_position)*PULL_SPEED*delta/500)
		velocity += (Global.ball.global_position-global_position)*PULL_SPEED*delta/100
		
		hook_timer += delta
		if global_position.distance_to(Global.ball.position)*Global.SCALE <= radius+Global.ball.radius or hook_timer >= MAX_HOOKTIME: 
			$hook.pitch_scale = 1.0
			$hook.play()
			hooked = false
		
		Global.ball.circle_rotation += 5
		Global.ball.can_hit = true
		Global.ball.hit_color = Color(0.75, 0.0, 0.0, 1)
		
	else:
		hook_timer = clamp(hook_timer-delta, 0, MAX_HOOKTIME)
	
	move_and_slide(velocity*144*max_speed_mult)
	
	circle_rotation += 0.5
	update()

func _input(event):
	if event.is_action_pressed("dash") and Global.SOCCAR_MODE and global_position.distance_to(Global.ball.global_position) <= radius + Global.ball.radius + Global.hit_buffer:
			Global.ball.apply_impulse(Vector2.ZERO, global_position.direction_to(Global.ball.global_position)*Global.hit_power)
			kick_delay = Global.KICK_DELAY
			
	elif event.is_action_pressed("dash") and dashes > 0 and (event.device == id or id == 4):
		dashes -= 1
		velocity = velocity.normalized()*dash_speed
		if hooked:
			Global.ball.max_speed *= 2
			velocity *= 3
		dash_timer = 0.0
	if event.is_action_pressed("hook") and global_position.distance_to(Global.ball.position) <= ring_size+Global.ball.radius and (event.device == id or id == 4) and not (has_paddle and Global.PADDLE_BALL):
		#exits dribbleing
		Global.ball.linear_damp = Global.BASE_DAMP
		if Global.SOCCAR_MODE and global_position.distance_to(Global.ball.global_position) <= radius + Global.ball.radius + Global.hit_buffer:
			Global.ball.apply_impulse(Vector2.ZERO, global_position.direction_to(Global.ball.global_position)*Global.hit_power)
			kick_delay = Global.KICK_DELAY
		else:
			$hook.pitch_scale = 2.0
			$hook.play()
			for plr in Global.players:
				if plr[1].hooked:
					plr[1].hooked = false
			hooked = true
		
		
	if event.is_action_released("hook") and (event.device == id or id == 4):
		if hooked:
			$hook.pitch_scale = 1.0
			$hook.play()
		kick_delay = Global.KICK_DELAY/5.0
		hooked = false
		
		
func _draw():
	if hooked:
		draw_line(Vector2.ZERO, Global.ball.global_position-global_position, Global.team_colors[team], 5, true)
		# no idea why the number 144 works
		draw_arc(Vector2.ZERO, radius+40, 0, deg2rad(144*(MAX_HOOKTIME-hook_timer)), 128, Color(1, (MAX_HOOKTIME-hook_timer), (MAX_HOOKTIME-hook_timer), 0.5), 2, true)
		
	draw_circle(Vector2.ZERO, radius, Global.team_colors[team])
#	draw_circle(Vector2.ZERO, radius-5/Global.SCALE, colors[player_num])
	
	if circle_rotation >= 360: circle_rotation = 0
	for i in range(lines):
		if i%2 == 0:
			draw_arc(Vector2.ZERO, ring_size, deg2rad(i*360.0/lines+circle_rotation), deg2rad((i+1)*360.0/lines+circle_rotation), 5, Color(Global.team_colors[team].r, Global.team_colors[team].g, Global.team_colors[team].b, 0.25), 3, true)
	
	var count = 0
	for i in range(max_dashes*2):
		if i%2 == 0:
			count += 1
			if count <= dashes:
				draw_arc(Vector2.ZERO, radius+20, deg2rad(i*30/max_dashes*2.0-90), deg2rad((i+1)*30/max_dashes*2.0-90), 40, Color(0.0, 0, 0), 3, true)
			
			

func change_dash(num = 1):
	if num > 0:
		pass
	elif num < 0:
		pass
	
	else: return
