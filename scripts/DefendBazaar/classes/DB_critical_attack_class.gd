extends Node

class_name DB_critical_attack_class
var attack_name: String
var description: String
var damage: Array


func _init(p_attack_name: String, p_description: String, p_damage: Array) -> void:
    attack_name = p_attack_name
    description = p_description
    damage = p_damage