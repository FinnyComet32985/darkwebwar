extends CharacterBody2D

@export var attack_type: String
var life:int = 100

var curve: Curve2D = null
var path_position := 0.0
@export var speed := 100.0
var paths:Array = []
var path_index: int


func set_attack(type: String, percentage: int) -> void:
	self.attack_type = type
	self.life = percentage
	$Life.text = str(life)

	match type:
		"DDoS":
			$CollisionShape2D/TextureRect.texture = load("res://assets/DefendBazaar/attacks/DarkWebWar-DDoS.svg")
		"Port scanning":
			$CollisionShape2D/TextureRect.texture = load("res://assets/DefendBazaar/attacks/DarkWebWar-PortScanning.svg")
		"Banner grabbing":
			$CollisionShape2D/TextureRect.texture = load("res://assets/DefendBazaar/attacks/DarkWebWar-BannerGrab.svg")
		"Path trasversal":
			$CollisionShape2D/TextureRect.texture = load("res://assets/DefendBazaar/attacks/DarkWebWar-PathTrasversal.svg")
		_:
			pass

func _physics_process(delta: float) -> void:
	if curve==null:
		return
	else:
		path_position += speed * delta
		global_position = curve.sample_baked(path_position)
	
func start_following_curve(new_curve: Curve2D) -> void:
	curve=new_curve

func set_curve_to_follow(curves: Array) -> void:
	paths=curves
	path_index=0
	path_position = 0.0
	self.start_following_curve(curves[0].curve)

func continue_new_curve() -> void:
	path_index+=1
	path_position = 0.0
	$Life.text=str(self.life)
	self.start_following_curve(paths[path_index].curve)


func make_damage(structure_type) -> void:
	# avvio animazione danno alla struttura
	$"../../../".update_damage(self.attack_type, structure_type)
