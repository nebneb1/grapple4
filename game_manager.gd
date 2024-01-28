extends Node2D

func _ready():
	get_node("transition").modulate = Global.color
	Global.main = self
	get_tree().paused = true
	$transition.emitting = true
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
