extends Area2D

@export var structure_type: String


func _on_body_entered(body: Node2D) -> void:
	body.make_damage(structure_type)
	get_tree().current_scene.remove_attack(body)
	body.queue_free()
