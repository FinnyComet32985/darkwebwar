extends HBoxContainer

func attack_init(new_texture: Resource, attack_type: String, perc_redunction:int) -> void:
	$TextureRect.texture = new_texture
	$AttackName.text = attack_type
	$AttackLifeRedunction.text = "- "+str(perc_redunction)
