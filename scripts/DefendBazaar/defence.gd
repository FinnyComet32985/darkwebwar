extends Button

@export var node_id: int
@export var type: String
@export var level: int = 1

var _cost := 0

var firewall = preload("res://assets/temp/Firewall.png")
var honeypot = preload("res://assets/temp/Honeypot.png")
var ids = preload("res://assets/temp/DarkWebWar-IDS.png")
var ratelimiter = preload("res://assets/temp/DarkWebWar-RateLimiter.png")
var defence_loaded = {
	"firewall": firewall,
	"honeypot": honeypot,
	"ids": ids,
	"Rate Limiter": ratelimiter
}

func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))
	

func _on_pressed() -> void:
	if $"../../DefenceMenu".visible == true:
		$"../../DefenceMenu".visible=0
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
	if self.type == "Rate Limiter":
		self.icon=ratelimiter
		self.type = "Rate Limiter"
	$"../../../".defence_built.append(type)

func open_menu() -> void:
	if type!="":
		$"../../DefenceMenu".visible=1
		$"../../DefenceMenu/Info/Tipo/tipo-stat".text=self.type
		$"../../DefenceMenu/Info/Tipo/tipo".texture=defence_loaded[self.type]
		$"../../DefenceMenu/Info/Level/level_stat".text = str(self.level)

		var other_info = $"../../../".get_defence_other_info(self.type, self.level)
		_cost = other_info[0]
		$"../../DefenceMenu/Info/Level/cost_stat".text = str(other_info[0])+" ₿"

		if _cost > $"../../../".btc:
			$"../../DefenceMenu/Info/Level/UpgradeButton".visible = 0 

		var blocked_attack = ""
		for attack in other_info[1]:
			blocked_attack += attack + "\n"
		$"../../DefenceMenu/Info/Eff_label".text = blocked_attack
		
	else:
		$"../../DefenceBuilder".visible=1
		$"../../DefenceBuilder".defence=self

func upgrade():
	$"../../".btc=$"../../".btc-_cost
	$"../../".update_btc()
	level+=1
	$"../DefenceMenu/Info/Level/level_stat".text = str(self.level)
	var other_info = $"../../".get_defence_other_info(self.type, self.level)
	$"../DefenceMenu/Info/Level/cost_stat".text = str(other_info[0])+" ₿"

func update_path() -> void:
	for path in $"../../../".paths:
		for node in path:
			if node.id == self.node_id:
				node.type = self.type


func _on_area_2d_body_entered(body: Node2D) -> void:
	var finded = false
	for defence_type in DB_Level_definer.get_effective_defence($"../../../".n_level_playing, body.attack_type):
		if defence_type == self.type:
			finded=true
			body.life -= 20
			if body.life > 0:
				body.continue_new_curve() 
			else:
				body.queue_free()
	if finded==false:
		body.continue_new_curve()
