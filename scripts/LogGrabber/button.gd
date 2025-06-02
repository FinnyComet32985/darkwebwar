extends Button

var icons = {
	"log": "",
	"folder": "",
	"script": ""
}

var name_text: String = ""
var type: String = ""


func init_button(_name_text: String, _type: String) -> void:
	name_text = _name_text
	$".".text = name_text
	type = _type
	# $".".icon = icons[type]
