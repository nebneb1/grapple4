extends RichTextLabel

onready var scores = Global.scores

func _ready():
	Global.scoreboard = self
	bbcode_text = "[center][color=#" + str(Global.team_colors[0].to_html()) + "]" + str(scores[1]) + "[/color] - [color=#" + str(Global.team_colors[1].to_html()) + "]" + str(scores[0])
	
func update_score(goal_num : int, ammount: int):
	scores[goal_num-1] += ammount
	bbcode_text = "[center][color=#" + str(Global.team_colors[0].to_html()) + "]" + str(scores[1]) + "[/color] - [color=#" + str(Global.team_colors[1].to_html()) + "]" + str(scores[0])
