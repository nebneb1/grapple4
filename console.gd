extends RichTextLabel

#func _ready():
	#push("hi!")

var TAGS = [
	["default", Color(1,1,1,0.75).to_html()], 
	["warn", Color(1,1,0).to_html()], 
	["alert", Color(1,0,0).to_html()],
	["none", Color(1,1,1).to_html()],
	["info", Color(0,1,1).to_html()]]


func push(item, tag : String = "default"):
	var time = Time.get_time_dict_from_system()
	var out = ""
	
	item = str(item)
	for i in TAGS: if i[0] == tag: out += "[color=" + i[1] + "]"
	if tag != "info": out += "[%02d:%02d:%02d] " % [time.hour, time.minute, time.second]
	if tag == "alert": out += "ALERT: "
	out += item + "[/color]\n"
	
	text = text + out
