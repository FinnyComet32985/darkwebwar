extends VBoxContainer


func _on_visibility_changed() -> void:
	if $".".visible == true:
		$VBoxContainer/start.grab_focus()

# start
func _on_start_focus_entered() -> void:
	$VBoxContainer/start/AnimationPlayer.play("start_hover")
func _on_start_focus_exited() -> void:
	$VBoxContainer/start/AnimationPlayer.play("RESET")
func _on_start_mouse_entered() -> void:
	$VBoxContainer/start/AnimationPlayer.play("start_hover")
func _on_start_mouse_exited() -> void:
	$VBoxContainer/start/AnimationPlayer.play("RESET")


# exit
func _on_exit_focus_entered() -> void:
	$VBoxContainer/exit/AnimationPlayer.play("exit_hover")
func _on_exit_focus_exited() -> void:
	$VBoxContainer/exit/AnimationPlayer.play("RESET")
func _on_exit_mouse_entered() -> void:
	$VBoxContainer/exit/AnimationPlayer.play("exit_hover")
func _on_exit_mouse_exited() -> void:
	$VBoxContainer/exit/AnimationPlayer.play("RESET")


func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		if $VBoxContainer/start.has_focus():
			_on_start_pressed()
			accept_event()
		elif $VBoxContainer/exit.has_focus():
			_on_exit_pressed()
			accept_event()


func _on_start_pressed() -> void:
	Global.save_data["scene"]="0"
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
	
