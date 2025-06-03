extends Panel

var button_scene = preload("res://scenes/LogGrabber/button.tscn")

@onready var fs_section = $PlayZone/ScrollContainer/fs_container
@onready var path_label = $PlayZone/Func/Path/Label

var n_level:= 1
var level: LG_Level_class
var current_level_file_system: Dictionary

var undo: Array[String] = []
var redo: Array[String] = []

var logs_to_delete_count = 0

var injected:= false

func _ready() -> void:

	init_level()

func _process(_delta: float) -> void:
	if $GameTimer != null && $GameTimer.wait_time > 0:
		$"Status-container/Stat/RemaningTime/remaning-time-stat".text = str(int($GameTimer.time_left))+ " s"
	if $ScanTimer != null && $ScanTimer.wait_time > 0:
		$"Status-container/Stat/RemaningScanTime/remaning-scan-time-stat".text = str(int($ScanTimer.time_left))+ " s"


func init_level() -> void:
	level = LG_Level_definer.get_level(n_level)
	current_level_file_system = level.file_system.duplicate(true)

	if $GameTimer:
		$GameTimer.wait_time = level.time

	undo.clear()
	redo.clear()
	logs_to_delete_count = 0


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
		
	if !undo.has("C:"):
		undo.append("C:")
	_update_path_label()

	for item_name in level.file_system:
		if level.file_system[item_name].has("type") and level.file_system[item_name]["type"] == "log" and level.file_system[item_name].has("delete") and level.file_system[item_name]["delete"]:
			logs_to_delete_count += 1
	$"Status-container/Stat/RemLog/rem-log-stat".text = str(logs_to_delete_count)

	$ScanTimer.wait_time = level.scan_timer
	
	$GameTimer.start()
	$ScanTimer.start()


func _on_game_timer_timeout() -> void:
	game_over()

func game_over()->void:
	print("GAME OVER")

func game_win()->void:
	print("GAME WIN")


func open_log(_name: String) -> void:
	$LogViewerSec.visible = true
	$LogViewerSec/LogViewer/Title.text = _name
	$LogViewerSec/LogViewer/Description.text = level.file_system[_name]["content"]
	$LogViewerSec/LogViewer.visible = true

func _update_path_label() -> void:
	if path_label:
		if !undo.is_empty():
			path_label.text = "/".join(undo)
		else:
			path_label.text = "" # In caso undo sia vuoto (non dovrebbe accadere dopo init)

func open_folder(_name: String, is_history_navigation: bool = false) -> void:
	if !is_history_navigation:
		undo.append(_name)
		redo.clear()

	for child in fs_section.get_children():
		child.queue_free()

	if current_level_file_system.has(_name) and current_level_file_system[_name].has("children"):
		for child_name in current_level_file_system[_name]["children"]:
			if current_level_file_system.has(child_name) and current_level_file_system[child_name].has("type"):
				var element = button_scene.instantiate()
				element.init_button(child_name, level.file_system[child_name]["type"])
				fs_section.add_child(element)
			else:
				printerr("Elemento figlio o tipo mancante nel file_system per: ", child_name, " dentro ", _name)
	else:
		printerr("Cartella non trovata o senza figli: ", _name)
	
	_update_path_label()


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
	


func _on_delete_pressed() -> void:
	if level.file_system.has($LogViewerSec/LogViewer/Title.text):
		if level.file_system[$LogViewerSec/LogViewer/Title.text]["delete"] == true:
			logs_to_delete_count -= 1
			$"Status-container/Stat/RemLog/rem-log-stat".text = str(logs_to_delete_count)
			if logs_to_delete_count == 0:
				game_win()
		else:
			if $ScanTimer.wait_time-10> 20 && $ScanTimer.time_left-10>0:
				var temp_time_wait = $ScanTimer.wait_time-10
				var temp_time_left = $ScanTimer.time_left-10
				$ScanTimer.stop()
				$ScanTimer.wait_time = temp_time_left
				$ScanTimer.start()
				$ScanTimer.wait_time = temp_time_wait
			
	if current_level_file_system.has($LogViewerSec/LogViewer/Title.text):
		current_level_file_system.erase($LogViewerSec/LogViewer/Title.text)
	open_folder(undo.back(), true)

	$LogViewerSec/LogViewer.visible = false
	$LogViewerSec.visible = false



func _on_mantain_pressed() -> void:
	$LogViewerSec/LogViewer.visible = false
	$LogViewerSec.visible = false



func _on_scan_timer_timeout() -> void:
	if injected == false:
		game_over()
	else:
		injected = false
		$ScanTimer.wait_time -=10
		$ScanTimer.start()

var opened_script: String = ""

func open_script(_name: String) -> void:	
	$"ScanSec/Injector/VBoxContainer/Patch-sec/AnimationPlayer".play("RESET")
	$"ScanSec/Injector/VBoxContainer/Inject-sec/AnimationPlayer".play("RESET")
	$ScanSec.visible = true
	$ScanSec/Injector.visible = true
	$"ScanSec/Injector/Button/Patch-sec/Patch".disabled = false
	$"ScanSec/Injector/Button/Patch-sec/Inject".disabled = true
	opened_script = _name

func _on_patch_pressed() -> void:
	$"ScanSec/Injector/Button/Patch-sec/Patch/Patch_timer".start()
	$"ScanSec/Injector/Button/Patch-sec/Patch".disabled = true
	$"ScanSec/Injector/Button/Patch-sec/Inject".disabled = true
	$ScanSec/Injector/Button/Close.disabled = true
	$"ScanSec/Injector/VBoxContainer/Patch-sec/AnimationPlayer".play("patch")
	for i in range(4):
		$ScanSec/Injector/term/RichTextLabel.text += level.file_system[opened_script]["injection_output"][i]+"\n"
		await get_tree().create_timer(0.8).timeout

func _on_patch_timer_timeout() -> void:
	$"ScanSec/Injector/Button/Patch-sec/Inject".disabled = false

func _on_inject_pressed() -> void:
	$"ScanSec/Injector/Button/Patch-sec/Inject/Inject_timer".start()
	$"ScanSec/Injector/Button/Patch-sec/Inject".disabled = true
	$"ScanSec/Injector/VBoxContainer/Inject-sec/AnimationPlayer".play("inject")
	for i in range(4, 8):
		$ScanSec/Injector/term/RichTextLabel.text += level.file_system[opened_script]["injection_output"][i]+"\n"
		await get_tree().create_timer(0.5).timeout

func _on_inject_timer_timeout() -> void:
	injected = true
	$ScanSec/Injector/Button/Close.disabled = false


func _on_close_pressed() -> void:
	if injected == true:
		var temp_scan_time_rem = $ScanTimer.time_left
		var temp_game_time_left = $GameTimer.time_left
		$ScanTimer.stop()
		if $ScanTimer.wait_time - 10 > 20:
			$ScanTimer.wait_time -= 10 
		$GameTimer.wait_time = temp_game_time_left-temp_scan_time_rem
		$ScanTimer.start()
		$GameTimer.start()
		$ScanSec.visible = false
		$ScanSec/Injector.visible = false
		injected = false

	else:
		$ScanSec.visible = false
		$ScanSec/Injector.visible = false
