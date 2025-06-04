extends LineEdit

func _on_visibility_changed() -> void:
	if $".".visible == true:
		grab_focus()

var or_text:= ""

func _on_text_changed(new_text: String) -> void:
	if len(or_text)<len(new_text):
		var random_pitch = randf_range(0.8, 1.5)
		$AudioStreamPlayer.pitch_scale = random_pitch
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.pitch_scale = 0.6
		$AudioStreamPlayer.play()
	or_text=new_text
