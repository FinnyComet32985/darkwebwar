extends Node

class_name RF_level_class
var level_max_time: int
var spawn_rate: float 
var fall_speed: float 
var dictionary: Dictionary
# {
#     string : int // word : difficulty
# }

func _init(p_level_max_time: int, p_spawn_rate: float, p_fall_speed: float, p_dictionary: Dictionary):
	self.level_max_time = p_level_max_time
	self.spawn_rate = p_spawn_rate
	self.fall_speed = p_fall_speed
	self.dictionary = p_dictionary
