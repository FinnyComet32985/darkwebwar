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
	$Attack.text = self.attack_type
	$Life.text = str(life)

	$CollisionShape2D/TextureRect.texture = DB_Icons.load_icon(self.attack_type)

	match type:
		"DDoS":
			$CollisionShape2D/TextureRect.size = Vector2(90, 65.0)
			$CollisionShape2D/TextureRect.position = Vector2(-28, -28)
		"Port scanning":
			$CollisionShape2D/TextureRect.position = Vector2(-24, -28)
		"Banner grabbing":
			$CollisionShape2D/TextureRect.scale = Vector2(0.4, 0.4) 
			$CollisionShape2D/TextureRect.size = Vector2(168.0, 65.0)
			$CollisionShape2D/TextureRect.position = Vector2(-36, -15)

		"Path trasversal":
			$CollisionShape2D/TextureRect.scale = Vector2(0.5, 0.5) 
			$CollisionShape2D/TextureRect.position = Vector2(-24, -20)
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

func reload_life() -> void:
	$Life.text = str(life)

func explode() -> void:
	$CollisionShape2D/TextureRect.visible = false
	$Attack.visible = false
	$Life.visible = false
	$CollisionShape2D/AnimatedSprite2D.visible = true
	$CollisionShape2D/AnimatedSprite2D.play("default")
	$AudioStreamPlayer.play()
	await $CollisionShape2D/AnimatedSprite2D.animation_finished
