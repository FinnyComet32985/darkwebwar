extends Button

var icons = {
	"log": load("res://assets/LogGrabber/DarkWebWar-Log.svg"),
	"folder": load("res://assets/LogGrabber/DarkWebWar-Folder.svg"),
	"script": load("res://assets/LogGrabber/DarkWebWar-Script.svg")
}

@onready var root = get_tree().current_scene 

var name_text: String = ""
var type: String = ""


func init_button(_name_text: String, _type: String) -> void:
	name_text = _name_text
	$".".text = " "+name_text
	type = _type
	if icons.has(type):
		$".".icon = icons[type]


func _on_pressed() -> void:
	if type == "log":
		root.open_log(name_text)
	elif type == "folder":
		root.open_folder(name_text)
	elif type == "script":
		root.open_script(name_text)
