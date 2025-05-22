extends Node

class_name DB_Level_class
var level_num: int
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
# [
#	[ // attack 1
#		type // DDoS
#		attack_defence // difese che lo counterano
#		succ_perc // probabilità di successo
# 		damage {
#			attack_type: [damage conf, damage int, damage disp]
#			
#		}
#	]
# ]

# var static_attack: Array

var waves: Dictionary
# {
#	"wave 1": 
#		[ 
#			int // tempo durata ondata
#			int // tempo alla prossima ondata
#		]
# } 


func _init(new_level_num: int, new_static_defence_level_cost, new_placable_defence_level_cost, new_minimap, new_paths:Array, new_attacks: Array, new_waves: Dictionary) -> void:
	self.level_num = new_level_num
	self.static_defence_level_cost = new_static_defence_level_cost
	self.placable_defence_level_cost = new_placable_defence_level_cost
	self.minimap = new_minimap
	self.paths = new_paths
	self.attacks=new_attacks
	self.waves = new_waves


func get_upgrade_level_cost(upgrade_type: String, level: int) -> int:
	if upgrade_type == "Firewall":
		return self.placable_defence_level_cost["Firewall"][level]
	elif upgrade_type == "Web Application Firewall":
		return self.placable_defence_level_cost["Web Application Firewall"][level]
	elif upgrade_type == "Intrusion Detection System":
		return self.placable_defence_level_cost["Intrusion Detection System"][level]
	elif upgrade_type == "Rate Limiter":
		return self.placable_defence_level_cost["Rate Limiter"][level]
	else:
		return 0

func get_blocked_attack(defence_type: String) -> Array:
	var attacks_return = []
	for attack in attacks:
		for defence in attack.attack_defence:
			if defence == defence_type:
				attacks_return.append(attack.attack_type)
	return attacks_return

func get_prefered_target(attack_type: String) -> Array:
	for attack in attacks:
		if attack_type == attack.attack_type:
			return attack.damage.keys()
	return []

func get_effective_defence(attack_type: String) -> Dictionary:
	for attack in attacks:
		if attack_type == attack.attack_type:
			return attack.attack_defence
	return {}

func get_damage(attack_type: String, structure_type: String) -> Array:
	for attack in attacks:
		if attack_type == attack.attack_type:
			if structure_type in attack.damage:
				return attack.damage[structure_type]
	return []

func get_perc_redunction(attack_type:String, defence_type:String, defence_level:int) -> int:
	for attack in attacks:
		if attack.attack_type == attack_type:
			if defence_type in attack.attack_defence:
				return attack.attack_defence[defence_type][defence_level]
			
	return 0
