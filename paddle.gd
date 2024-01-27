extends KinematicBody2D


onready var player = get_parent()
var id = 0 # set by parent
const ACCEL = 15.0
const DEADZONE = 0.3


#var connected := false
#var last_rot := 0.0

func _ready():
	$CollisionShape2D.position.y = -player.ring_size
	$CollisionShape2D.scale = Vector2(player.ring_size/60.0,player.ring_size/60.0)
#	$CollisionShape2D2.position.y = +player.ring_size
#	$CollisionShape2D2.scale = Vector2(player.ring_size/60.0,player.ring_size/60.0)

func _physics_process(delta):
	if not player.disabled:
		var aim: Vector2
		aim.x = Input.get_joy_axis(id, 2)
		aim.y = Input.get_joy_axis(id, 3)
	#	aim.x = int(Input.is_action_pressed("right"))-int(Input.is_action_pressed("left"))
	#	aim.y = int(Input.is_action_pressed("down"))-int(Input.is_action_pressed("up"))
	#	rotation = lerp(rotation, atan2(aim.y, aim.x) + PI/2, delta*ACCEL/2)
	#	rotation = lerp(rotation, rotation+get_angle_to(aim)*10, delta*ACCEL)
	#	rotation = atan2(aim.y, aim.x) + PI/2
	#	print(aim)
	#	look_at(to_global(aim))
		aim = aim.normalized()
		if aim.length() > DEADZONE:
			rotation = lerp_angle(rotation, atan2(aim.y, aim.x) + PI/2, delta*ACCEL)
#		if connected and last_rot == rotation:
#			connected = false
#			$CollisionShape2D/PinJoint2D.set_node_b("")
		
#		last_rot = rotation
		
	else:
		rotation += 5.0*delta
	
	
	
	


#func _on_Area2D_body_entered(body):
#	if body.is_in_group("ball"):
#		connected = true
#		$CollisionShape2D/PinJoint2D.set_node_b(NodePath(body.get_path()))
#
#
#func _on_Area2D_body_exited(body):
#	if body.is_in_group("ball"):
#		connected = false
#		$CollisionShape2D/PinJoint2D.set_node_b(NodePath(""))
