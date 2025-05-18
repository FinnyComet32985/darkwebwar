extends Node

class_name AttackClass
var attack_type: String
var attack_defence: Array
var prefered_target: Array
var succ_perc: int

func _init(new_attack_type: String, new_attack_defence: Array, new_prefered_target: Array, new_succ_perc: int) -> void:
    self.attack_type = new_attack_type
    self.attack_defence = new_attack_defence
    self.prefered_target = new_prefered_target
    self.succ_perc=new_succ_perc