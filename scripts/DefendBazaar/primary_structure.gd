extends Area2D

@export var structure_type: String


func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
