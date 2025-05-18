extends Panel

func load_settings() -> void:
	$ScrollContainer/VBoxContainer/CRT.button_pressed = Global.save_data["settings"]["crt"]
	$"../../CanvasLayer".visible = $ScrollContainer/VBoxContainer/CRT.button_pressed
	
	$ScrollContainer/VBoxContainer/Fullscreen.button_pressed = Global.save_data["settings"]["fullscreen"]
	
	if Global.save_data["settings"]["fullscreen"] == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	$ScrollContainer/VBoxContainer/Animazioni.button_pressed = Global.save_data["settings"]["skip_animation"]
	
func _on_back_pressed() -> void:
	$".".visible = 0 
	$"../Menu".visible = 1


func _on_crt_pressed() -> void:
	$"../../CanvasLayer".visible = $ScrollContainer/VBoxContainer/CRT.button_pressed
	Global.save_data["settings"]["crt"] = $ScrollContainer/VBoxContainer/CRT.button_pressed


func _on_fullscreen_pressed() -> void:
	var current_mode = DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Global.save_data["settings"]["fullscreen"] = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Global.save_data["settings"]["fullscreen"] = true


func _on_animazioni_pressed() -> void:
	Global.save_data["settings"]["skip_animation"] = $ScrollContainer/VBoxContainer/Animazioni.button_pressed

func _on_visibility_changed() -> void:
	if $".".visible == true:
		$Back.grab_focus()


func _on_back_focus_entered() -> void:
	$Back/AnimationPlayer.play("back_hover")
func _on_back_focus_exited() -> void:
	$Back/AnimationPlayer.play("RESET")
func _on_back_mouse_entered() -> void:
	$Back/AnimationPlayer.play("back_hover")
func _on_back_mouse_exited() -> void:
	$Back/AnimationPlayer.play("RESET")
