extends RigidBody2D

@export var attack_type: String
@export var speed: float
const EPS:=1

const TARGET_X = 347.0

var spawn_x: float

var entered_protected_node: bool = false

func _ready() -> void:
	spawn_x = self.position.x

func _physics_process(delta: float) -> void:
	if entered_protected_node == false:
		var cur_x = self.position.x
		if abs(cur_x - TARGET_X) <= EPS:
			self.linear_velocity.x = 0
			return
	
		var dir := 0.0
		if is_equal_approx(spawn_x, 230.0):
			if cur_x < TARGET_X:
				dir = 1.0
		elif is_equal_approx(spawn_x, 480.0):
			if cur_x > TARGET_X:
				dir = -1.0
		elif is_equal_approx(spawn_x, TARGET_X):
			dir = 0.0
		else:
			dir = sign(TARGET_X - spawn_x)
		self.linear_velocity.x = dir * speed
	else:
		self.queue_free()
	
