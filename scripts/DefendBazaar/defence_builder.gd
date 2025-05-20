extends Panel



var defence_button: Button


func _on_back_button_pressed() -> void:
	$".".visible=0


func _on_visibility_changed() -> void:
	var defence = get_node("ScrollContainer/defence")
	for child in defence.get_children():
		child.set_build_button()
