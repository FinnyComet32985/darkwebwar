extends Control

var path := "user://saveData.json"
var button_pressed
# CONTINUE
func _on_continue_mouse_entered() -> void:
	$Continue/AnimationPlayer.play("Continue_hover")
func _on_continue_mouse_exited() -> void:
	$Continue/AnimationPlayer.play("RESET")
func _on_continue_focus_entered() -> void:
	$Continue/AnimationPlayer.play("Continue_hover")
func _on_continue_focus_exited() -> void:
	$Continue/AnimationPlayer.play("RESET")


# NEW GAME
func _on_new_game_mouse_entered() -> void:
	$NewGame/AnimationPlayer.play("NewGame_hover")
func _on_new_game_mouse_exited() -> void:
	$NewGame/AnimationPlayer.play("RESET")
func _on_new_game_focus_entered() -> void:
	$NewGame/AnimationPlayer.play("NewGame_hover")
func _on_new_game_focus_exited() -> void:
	$NewGame/AnimationPlayer.play("RESET")


# SETTINGS
func _on_settings_mouse_entered() -> void:
	$Settings/AnimationPlayer.play("Settings_hover")
func _on_settings_mouse_exited() -> void:
	$Settings/AnimationPlayer.play("RESET")
func _on_settings_focus_entered() -> void:
	$Settings/AnimationPlayer.play("Settings_hover")
func _on_settings_focus_exited() -> void:
	$Settings/AnimationPlayer.play("RESET")


func check_file():
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var contenuto = file.get_as_text()
		file.close()

		var risultato = JSON.parse_string(contenuto)
		if risultato is Dictionary:
			Global.save_data = risultato
		else:
			Global.save_data = {}
	else:
		$Continue.visible = 0

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.write_data()
		get_tree().quit()

func _on_new_game_pressed() -> void:
	$".".visible = 0
	$"../username".visible = 1
	var random_pitch = randf_range(0.1, 2)
	$"../../AudioStreamPlayer-click".pitch_scale = random_pitch
	$"../../AudioStreamPlayer-click".play()
	


func _on_settings_pressed() -> void:
	$".".visible = 0
	$"../Settings".visible= 1
	var random_pitch = randf_range(0.1, 2)
	$"../../AudioStreamPlayer-click".pitch_scale = random_pitch
	$"../../AudioStreamPlayer-click".play()


func _on_username_input_text_submitted(new_text: String) -> void:
	$"../username".visible = 0
	var us = new_text.to_upper()
	Global.save_data["username"]=us
	Global.username= Global.save_data["username"]
	$"../loading".visible = 1
	$"../loading/AnimationPlayer".play("loading")
	Global.scrivi_su_file(Global.save_data, path)
	Global.scrivi_su_file(Global.temp, Global.path_visited)
	var random_pitch = randf_range(0.1, 2)
	$"../../AudioStreamPlayer-click".pitch_scale = random_pitch
	$"../../AudioStreamPlayer-click".play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "loading":
		$"../loading".visible = 0
		if button_pressed != "continue":
			$"../Intro".visible = 1
		else:
			get_tree().change_scene_to_file("res://scenes/game.tscn")


func _ready():
	check_file()
	await $"../Settings".load_settings()
	
func initialize_focus():
	if $Continue.visible == false:
		$NewGame.grab_focus()
	else:
		$Continue.grab_focus()


func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		if $Continue.has_focus():
			_on_continue_pressed()
			accept_event()
		elif $NewGame.has_focus():
			_on_new_game_pressed()
			accept_event()
		elif $Settings.has_focus():
			_on_settings_pressed()
			accept_event()
		else:
			pass


func _on_continue_pressed() -> void:
	$".".visible = false
	button_pressed = "continue"
	$"../loading".visible = 1
	$"../loading/AnimationPlayer".play("loading")
	Global.load_visited()
	var random_pitch = randf_range(0.1, 2)
	$"../../AudioStreamPlayer-click".pitch_scale = random_pitch
	$"../../AudioStreamPlayer-click".play()
	

func _on_visibility_changed() -> void:
	if $".".visible==true:
		initialize_focus()
