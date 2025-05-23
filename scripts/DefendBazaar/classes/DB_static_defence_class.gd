extends Node

class_name DB_static_defence_class
var static_defence_type: String
var activation_cost: int
var manteing_cost: int
var level_cost: Array
var effect: Array

func _init(new_static_defence_type: String, new_activation_cost: int, new_manteing_cost: int, new_level_cost: Array, new_effect: Array) -> void:
	self.static_defence_type = new_static_defence_type
	self.activation_cost = new_activation_cost
	self.manteing_cost = new_manteing_cost
	self.level_cost = new_level_cost
	self.effect = new_effect

