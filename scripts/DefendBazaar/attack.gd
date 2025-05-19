extends CharacterBody2D

@export var attack_type: String
var life:int = 100


var curve: Curve2D = null
var path_position := 0.0
@export var speed := 100.0
var paths:Array = []
var path_index: int

func _ready() -> void:
	self.attack_type="DDoS"
	$Life.text = str(life)

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
	$Life.text=str(life)
	self.start_following_curve(paths[path_index].curve)
