extends Panel

var button_scene = preload("res://scenes/LogGrabber/button.tscn")

@onready var fs_section = $PlayZone/ScrollContainer/fs_container

var n_level:= 1 
var level: LG_Level_class

func _ready() -> void:

	init_level()

func _process(_delta: float) -> void:
	if $GameTimer != null && $GameTimer.wait_time > 0:
		$"Status-container/Stat/RemaningTime/remaning-time-stat".text = str(int($GameTimer.wait_time))+ " s"


func init_level() -> void:
	level = LG_Level_definer.get_level(n_level)
	$GameTimer.wait_time = level.time

	for fs in level.file_system:
		if level.file_system[fs]["father"] == null:
			var element = button_scene.instantiate()
			element.init_button(fs, level.file_system[fs]["type"])
			fs_section.add_child(element)

	
