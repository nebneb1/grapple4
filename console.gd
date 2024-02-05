extends RichTextLabel
var line_count = 0
const MAX_LINE_COUNT = 200
#func _ready():
	#push("hi!")

var TAGS = [
	["default", Color(1,1,1,0.5).to_html()], 
	["warn", Color(1,1,0).to_html()], 
	["alert", Color(1,0,0).to_html()],
	["none", Color(1,1,1).to_html()],
	["info", Color(0,1,1).to_html()]]


func push(item, tag : String = "default"):
	var time = Time.get_time_dict_from_system()
	var out = ""
	
	item = str(item)
	for i in TAGS: if i[0] == tag: out += "[color=" + i[1] + "]"
	if tag == "default": out += "[i]"
	if tag != "info": out += "[%02d:%02d:%02d] " % [time.hour, time.minute, time.second]
	if tag == "alert": out += "ALERT: "
	if tag == "default": out += "[/i]"
	out += item + "[/color]\n"
	
	line_count += 1
	if line_count > MAX_LINE_COUNT:
		text = text.split("\n", true, 1)[1] + out
	else:
		text = text + out
