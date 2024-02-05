extends Area2D

@export var gradient: Gradient
@export var team_num := 1

var can_score := true

func _process(delta):
	for b in get_overlapping_bodies():
		if b.is_in_group("ball") and can_score:
			$CPUParticles2D.modulate = Global.team_colors[abs(team_num-1-1)]
			#kph
			$speednode/Speed.text = "[color=#"+gradient.sample(clamp((pow(b.linear_velocity.length()*Global.SCALE, 1.25)/131.0)/190.0, 0.0, 1.0)).to_html(false) + "]" + str(int(pow(b.linear_velocity.length(), 1.25)/131.0)) + " KPH!![/color]"
			if team_num == 2: $speednode.scale.x = -1
			$speednode/AnimationPlayer.play("flyout")
			#other
			b.drawing = false
			Global.scoreboard.update_score(team_num, 1)
			can_score = false
			$CPUParticles2D.emitting = true
			Engine.time_scale = 0.5
			Global.active = false
			await get_tree().create_timer(1.5).timeout
			Engine.time_scale = 1
			Global.players = []
			Global.active = true
			Global.color = Global.team_colors[abs(team_num-1-1)]
			get_tree().reload_current_scene()
			Global.countdown = 5.0
			
