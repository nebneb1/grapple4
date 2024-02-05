extends RigidBody2D

const radius := 60.0/Global.SCALE
const MAX_SPEED := 2000.0/Global.SCALE
var max_speed := 2000.0/Global.SCALE
var disable := false

var circle_rotation = 0
var can_hit := false
var color := Color(0,0,0)
var hit_color = Color(0.0, 0.75, 0.75, 1)
var kick_color = Color(0.75, 0.0, 0.75, 1)
var grav_scale = gravity_scale
var drawing := true
var can_kick := false

func _ready():
	Global.ball = self
	$CollisionShape2D.shape.radius = radius
	$CPUParticles2D.scale_amount_min /= Global.SCALE
	$CPUParticles2D.scale_amount_max /= Global.SCALE
	$CPUParticles2D2.scale_amount_min /= Global.SCALE 
	$CPUParticles2D2.scale_amount_max /= Global.SCALE 
	$CPUParticles2D2.initial_velocity_min /= Global.SCALE
	$CPUParticles2D2.initial_velocity_max /= Global.SCALE 
	if not Global.GRAVITY: 
		linear_damp = Global.BASE_DAMP
	
	
func _process(delta):
	if disable: linear_velocity = Vector2.ZERO
	
	if Global.GRAVITY: gravity_scale = grav_scale
	else: gravity_scale = 0
	
	if Global.SOCCAR_MODE:
		if linear_damp > Global.BASE_DAMP:
			linear_damp -= Global.DAMP_FALLOFF*delta
	
#		physics_material_override.absorbent = false
		can_kick = false
		for player in Global.players:
			player[1].max_speed_mult = 1.0
			if not player[1].hooked:
				if player[1].global_position.distance_to(global_position) <= player[1].radius + radius + Global.hit_buffer and player[1].kick_delay <= 0:
					if Global.GRAVITY: gravity_scale = 0
					player[1].max_speed_mult = 0.7
					can_kick = true
#					physics_material_override.absorbent = true
					linear_damp = Global.NEAR_DAMP
				
				elif player[1].global_position.distance_to(global_position) <= player[1].ring_size and player[1].kick_delay <= 0:
					if Global.GRAVITY: gravity_scale = grav_scale/2
					player[1].max_speed_mult = 0.875
					linear_damp = Global.NEAR_DAMP/2
			
			
	
	$CPUParticles2D.emitting = false
	if linear_velocity.length() > MAX_SPEED-500/Global.SCALE:
		$CPUParticles2D.emitting = true
	
	if max_speed > MAX_SPEED: 
		max_speed -= (MAX_SPEED/2)*delta
		$CPUParticles2D2.emitting = false
		if linear_velocity.length() > MAX_SPEED*2-1000/Global.SCALE:
			$CPUParticles2D2.direction = linear_velocity.normalized()
			$CPUParticles2D2.emitting = true
		
	queue_redraw()
	if not drawing:
		$CPUParticles2D.emitting = false
		$CPUParticles2D2.emitting = false

func _physics_process(delta):
	if linear_velocity.length() > max_speed:
		apply_central_impulse(-linear_velocity.normalized()*delta*((linear_velocity.length()-max_speed)/100))
#		color.r += 0.02
	
	else:
		pass
#		color.r -= 0.005
	
	circle_rotation += 1
	

#to add once i figure out the math
#func _input(event):
	#if Global.PRACTICE_MODE:
		#if event.is_action_pressed("pass"):
			#var plr = Global.players[0]
			#var targ = (plr.global_position + plr.velocity*global_position.distance_to(plr.global_position))

func _draw():
	if drawing:
		draw_circle(Vector2.ZERO, radius, color)
		if can_hit:
			can_hit = false
			if can_kick and Global.SOCCAR_MODE:
				for i in range(8):
					if i%2 == 0:
						draw_arc(Vector2.ZERO, radius+10, deg_to_rad(i*360.0/8+circle_rotation*2), deg_to_rad((i+1)*360.0/8+circle_rotation*2), 10, kick_color, 3, true)
			else:
				for i in range(8):
					if i%2 == 0:
						draw_arc(Vector2.ZERO, radius+10, deg_to_rad(i*360.0/8+circle_rotation), deg_to_rad((i+1)*360.0/8+circle_rotation), 10, hit_color, 3, true)
				
			hit_color = Color(0.0, 0.75, 0.75, 1)

