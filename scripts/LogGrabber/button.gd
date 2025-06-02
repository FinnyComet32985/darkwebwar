extends Button

var icons = {
	"log": load("res://assets/LogGrabber/DarkWebWar-Log.svg"),
	"folder": load("res://assets/LogGrabber/DarkWebWar-Folder.svg"),
	"script": load("res://assets/LogGrabber/DarkWebWar-Script.svg")
}

var name_text: String = ""
var type: String = ""


func init_button(_name_text: String, _type: String) -> void:
	name_text = _name_text
	$".".text = name_text
	type = _type
	if icons.has(type):
		$".".icon = icons[type]
