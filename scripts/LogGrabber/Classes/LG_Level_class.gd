extends Node

class_name LG_Level_class
var time: int
var scan_timer: int
var file_system: Dictionary

func _init(_time: int, _scan_timer: int, _file_system: Dictionary) -> void:
    self.time = _time
    self.scan_timer = _scan_timer
    self.file_system = _file_system


