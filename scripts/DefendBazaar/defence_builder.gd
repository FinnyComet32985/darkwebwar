extends Panel



var defence_button: Button


func _on_back_button_pressed() -> void:
	get_tree().current_scene.get_node("Close_menu").play()
	$".".visible=0
