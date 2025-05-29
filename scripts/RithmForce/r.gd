extends Button

var response_id
var correct = false

func _on_focus_entered() -> void:
	$"../AnimationPlayer".play("focussed")



func _on_focus_exited() -> void:
	$"../AnimationPlayer".play("RESET")


func _on_pressed() -> void:
	if correct == false:
		$"../AnimationPlayer".play("error")
		await $"../AnimationPlayer".animation_finished
		$".".disabled = true
		get_tree().current_scene.responded(response_id, correct)
	else:
		$"../AnimationPlayer".play("correct")
		await $"../AnimationPlayer".animation_finished
		
		$"../../../".visible = false
		$"../../../../AnimationPlayer".play("RESET")
		get_tree().current_scene.responded(correct)
