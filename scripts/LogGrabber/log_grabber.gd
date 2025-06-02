extends Panel

var button_scene = preload("res://scenes/LogGrabber/button.tscn")

@onready var fs_section = $PlayZone/ScrollContainer/fs_container

var n_level:= 1 
var level: LG_Level_class

var undo: Array[String] = []
var redo: Array[String] = []

func _ready() -> void:

	init_level()

func _process(_delta: float) -> void:
	if $GameTimer != null && $GameTimer.wait_time > 0:
		$"Status-container/Stat/RemaningTime/remaning-time-stat".text = str(int($GameTimer.wait_time))+ " s"


func init_level() -> void:
	level = LG_Level_definer.get_level(n_level)
	if $GameTimer:
		$GameTimer.wait_time = level.time

	undo.clear()
	redo.clear()

	for child in fs_section.get_children():
		child.queue_free()

	if level.file_system.has("C:") and level.file_system["C:"].has("children"):
		for fs_item_name in level.file_system["C:"]["children"]:
			if level.file_system.has(fs_item_name) and level.file_system[fs_item_name].has("type"):
				var element = button_scene.instantiate()
				element.init_button(fs_item_name, level.file_system[fs_item_name]["type"])
				fs_section.add_child(element)
			else:
				printerr("Elemento o tipo mancante nel file_system per: ", fs_item_name)
	else:
		printerr("Cartella 'C:' o i suoi figli non trovati nella definizione del livello.")
		
	undo.append("C:")

func open_log(_name: String) -> void:
	pass

func open_folder(_name: String, is_history_navigation: bool = false) -> void:
	if !is_history_navigation:
		undo.append(_name)
		redo.clear()

	for child in fs_section.get_children():
		child.queue_free()

	if level.file_system.has(_name) and level.file_system[_name].has("children"):
		for child_name in level.file_system[_name]["children"]:
			if level.file_system.has(child_name) and level.file_system[child_name].has("type"):
				var element = button_scene.instantiate()
				element.init_button(child_name, level.file_system[child_name]["type"])
				fs_section.add_child(element)
			else:
				printerr("Elemento figlio o tipo mancante nel file_system per: ", child_name, " dentro ", _name)
	else:
		printerr("Cartella non trovata o senza figli: ", _name)


func open_script(_name: String) -> void:	
	pass

func _on_back_pressed() -> void:
	if undo.size() <= 1:
		return
	
	var current_folder = undo.pop_back()
	redo.append(current_folder)
	
	var previous_folder = undo.back()
	open_folder(previous_folder, true)

func _on_forw_pressed() -> void:
	if redo.is_empty():
		return
	
	var next_folder = redo.pop_back()
	undo.append(next_folder)
	
	open_folder(next_folder, true)
	
