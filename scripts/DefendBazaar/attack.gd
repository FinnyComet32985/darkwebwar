extends CharacterBody2D

@export var attack_type: String

var curve: Curve2D = null
var path_position := 0.0
@export var speed := 100.0



func _ready() -> void:
	self.attack_type="DDoS"

func _physics_process(delta: float) -> void:
	if curve==null:
		return
	else:
		path_position += speed * delta
		global_position = curve.sample_baked(path_position)
	
func start_following_curve(new_curve: Curve2D) -> void:
	curve=new_curve
