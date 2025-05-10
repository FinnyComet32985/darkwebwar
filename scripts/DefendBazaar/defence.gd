extends Button

@export var type: String
@export var level: int = 1

var firewall = preload("res://assets/temp/Firewall.png")
var honeypot = preload("res://assets/temp/Honeypot.png")
var ids = preload("res://assets/temp/DarkWebWar-IDS.png")
var ratelimiter = preload("res://assets/temp/DarkWebWar-RateLimiter.png")
var defence_loaded = {
	"firewall": firewall,
	"honeypot": honeypot,
	"ids": ids,
	"ratelimiter": ratelimiter
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
	if self.type == "ids":
		self.icon=ids
		self.type = "ids"
	if self.type == "ratelimiter":
		self.icon=ratelimiter
		self.type = "ratelimiter"
	$"../../".defence_built.append(type)

func open_menu() -> void:
	if type!="":
		$"../DefenceMenu".visible=1
		$"../DefenceMenu/Info/Tipo/tipo-stat".text=self.type
		$"../DefenceMenu/Info/Tipo/tipo".texture=defence_loaded[self.type]
		$"../DefenceMenu/Info/Level/level_stat".text = str(self.level)

		var other_info = $"../../".get_defence_other_info(self.type, self.level)

		$"../DefenceMenu/Info/Level/cost_stat".text = str(other_info[0])+" ₿"
		
	else:
		$"../DefenceBuilder".visible=1
		$"../DefenceBuilder".defence=self

func upgrade():
	level+=1
	$"../DefenceMenu/Info/Level/level_stat".text = str(self.level)
	var other_info = $"../../".get_defence_other_info(self.type, self.level)
	$"../DefenceMenu/Info/Level/cost_stat".text = str(other_info[0])+" ₿"
