extends HBoxContainer

var texture: Resource
var attack_type: String


func attack_init(new_texture: Resource, attack_type: String) -> void:
	$TextureRect.texture = new_texture
	$AttackName.text = attack_type
