extends Node

class_name DB_Attack_class
var attack_type: String
var attack_defence: Array
var succ_perc: int
var damage: Dictionary
func _init(new_attack_type: String, new_attack_defence: Array, new_succ_perc: int, new_damage: Dictionary) -> void:
    self.attack_type = new_attack_type
    self.attack_defence = new_attack_defence
    self.succ_perc=new_succ_perc
    self.damage = new_damage