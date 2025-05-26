extends Control


func _ready() -> void:
	await get_tree().create_timer(20).timeout
	




func _on_end_game_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
