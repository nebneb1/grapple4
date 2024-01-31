extends RichTextLabel


func _process(delta):
	if not Global.PRACTICE_MODE:
		if int(Global.countdown) == -1:
			if int(Global.time)%60 > 9:
				text = "[center]" + str(int(Global.time/60)) + " : " + str(int(Global.time)%60)
			else:
				text = "[center]" + str(int(Global.time/60)) + " : 0" + str(int(Global.time)%60)
		
		else:
			text = "[center]" + str(int(Global.countdown))
	else:
		text = "[center]PRACTICE"
