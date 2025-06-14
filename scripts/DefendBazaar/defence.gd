extends Button

@export var node_id: int
@export var type: String
@export var level: int = 1

var cost := 0
var max_level 


func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed() -> void:
	open_menu()

func set_type(new_type: String) -> void:
	self.type = new_type
	self.icon = DB_Icons.load_icon(self.type)
	$Panel.visible = true
	$Panel/Label.text = str(level)

func open_menu() -> void:
	$"../../../Open_menu".play()
	if type!="":
		var other_info = $"../../../".get_defence_other_info(self.type, self.level)
		cost = other_info[0]
		max_level = other_info[2]
		$"../../DefenceMenu".max_level = other_info[2]
		$"../../DefenceMenu".open_menu(self.node_id, self.type, DB_Icons.load_icon(self.type), self.level, other_info[0], other_info[1])
		
	else:
		$"../../DefenceBuilder".visible=1
		$"../../DefenceBuilder".defence_button=self


func upgrade() -> void:
	if max_level>level:
		$"../../../".btc=$"../../../".btc-cost
		$"../../../".update_btc()
		self.level+=1
		$AudioStreamPlayer.play()
		if level==max_level:
			$"../../DefenceMenu/Info/Level/level_stat".text = "MAX"
			$"../../DefenceMenu/Info/Level/UpgradeButton".visible=0
			$"../../DefenceMenu/Info/Level/Cost".visible=0
			$"../../DefenceMenu/Info/Level/cost_stat".visible=0
		else:
			$"../../DefenceMenu/Info/Level/level_stat".text = str(self.level)
		var other_info = $"../../../".get_defence_other_info(self.type, self.level)
		$"../../DefenceMenu/Info/Level/cost_stat".text = str(other_info[0])+" ₿"

		for child in $"../../DefenceMenu/Efficenzy-container/VBoxContainer".get_children():
			child.queue_free()
		$"../../DefenceMenu".insert_attack(self.type, other_info[1], self.level)
		
		$Panel/Label.text = str(level)


func update_path() -> void:
	for path in $"../../../".paths:
		for node in path:
			if node.id == self.node_id:
				node.type = self.type


func _on_area_2d_body_entered(body: Node2D) -> void:
	var finded = false
	var attack_countered = $"../../../".level.get_effective_defence(body.attack_type)

	for defence_type in attack_countered.keys():
		if defence_type == self.type:
			finded=true
			body.life -= attack_countered[defence_type][level-1]
			if body.life > 0:
				body.continue_new_curve() 
			else:
				await body.explode()
				body.queue_free()
	if finded==false:
		body.continue_new_curve()
