extends Node

class_name LevelClass
var level_num: int
var n_of_wave: int
var static_defence_level_cost: Dictionary
# {
#     "patch": [0, 10, ...], index = level, value = cost
#     "antivirus": [0, 7],
#     "phishingRecognizer": [0, 10]
# }
var placable_defence_level_cost: Dictionary
# {
#     "firewall": [3, 6],
#     "honeypot": [1, 3],
#     "ids": [3, 6],
#     "rateLimiter": [2, 7]
#     # altro
# }
var minimap: String # path to minimap

# TODO working refactor
var paths: Array
# [
# 	[ // path 1 
#		node(
#			type // defence
#			vector2 // posizione della difesa
#			curve // curva fino alla struttura
#		),
# 		node(
#			type // struttura primaria
#			vector2 // posizione struttura	
#			curve // curva dal nodo precedente alla struttura		
#		)
#	], ...
# ]



var attacks: Array

func _init(new_level_num: int, new_n_of_wave: int, new_static_defence_level_cost, new_placable_defence_level_cost, new_minimap, new_paths:Array, new_attacks: Array) -> void:
	self.level_num = new_level_num
	self.n_of_wave = new_n_of_wave
	self.static_defence_level_cost = new_static_defence_level_cost
	self.placable_defence_level_cost = new_placable_defence_level_cost
	self.minimap = new_minimap
	self.paths = new_paths
	self.attacks=new_attacks


func get_upgrade_level_cost(upgrade_type: String, level: int) -> int:
	if upgrade_type == "firewall":
		return self.placable_defence_level_cost["firewall"][level]
	elif upgrade_type == "honeypot":
		return self.placable_defence_level_cost["honeypot"][level]
	elif upgrade_type == "ids":
		return self.placable_defence_level_cost["ids"][level]
	elif upgrade_type == "Rate Limiter":
		return self.placable_defence_level_cost["Rate Limiter"][level]
	else:
		return 0
