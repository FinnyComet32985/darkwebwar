extends Node

class_name PD_level_class
var time: int
var ttl: int
var furtivita: int

var map: Dictionary

func _init(_time: int = 0, _ttl: int = 0, _furtivita: int = 0, _map: Dictionary = {}):
	time = _time
	ttl = _ttl
	furtivita = _furtivita
	map = _map
