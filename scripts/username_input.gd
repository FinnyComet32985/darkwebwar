extends LineEdit

func _on_visibility_changed() -> void:
	if $".".visible == true:
		grab_focus()
