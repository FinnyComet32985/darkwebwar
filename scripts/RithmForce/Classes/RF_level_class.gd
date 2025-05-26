extends Node

class_name RF_level_class
var level_max_time: int
var spawn_rate: float 
var word_gravity: float 
var dictionary: Dictionary
# {
#     string : [int, int, int] // word : [difficulty, +%, -%] 
# }

func _init(p_level_max_time: int, p_spawn_rate: float, p_word_gravity: float, p_dictionary: Dictionary):
	self.level_max_time = p_level_max_time
	self.spawn_rate = p_spawn_rate
	self.word_gravity = p_word_gravity
	self.dictionary = p_dictionary
