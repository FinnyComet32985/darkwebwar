extends Area2D

@export var structure_type: String


func _on_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.visible = true
	$destroy.play()
	$AnimatedSprite2D.play("default")
	body.make_damage(structure_type)
	get_tree().current_scene.remove_attack(body)
	body.queue_free()
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.visible = false
