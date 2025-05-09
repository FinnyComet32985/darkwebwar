extends Button

@export var type: String

var firewall = preload("res://assets/temp/Firewall.png")
var honeypot = preload("res://assets/temp/Honeypot.png")
var defence_loaded = {
	"firewall": firewall,
	"honeypot": honeypot
}

func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))
	

func _on_pressed() -> void:
	if $"../DefenceMenu".visible == true:
		$"../DefenceMenu".visible=0
	else:
		open_menu()

func set_type(new_type: String) -> void:
	self.type = new_type
	if type == "firewall":
		self.icon=firewall
		self.type="firewall"
		
	if self.type == "honeypot":
		self.icon=honeypot
		self.type = "honeypot"

func open_menu() -> void:
	if type!="":
		$"../DefenceMenu".visible=1
		$"../DefenceMenu/Info/Tipo/tipo-stat".text=self.type
		$"../DefenceMenu/Info/Tipo/tipo".texture=defence_loaded[self.type]
	else:
		$"../DefenceBuilder".visible=1
		$"../DefenceBuilder".defence=self
