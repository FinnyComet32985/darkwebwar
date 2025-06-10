extends Panel

var attack_redunction = preload("res://scenes/DefendBazaar/defence_attack_redunction.tscn")


func open_menu(type:String, icon:Resource, attacks: Array):
	var elements = $"Efficenzy-container/VBoxContainer".get_children()
	for element in elements:
		element.queue_free()
	$".".visible=true
	$"Info/Tipo/tipo-stat".text = type
	$Info/Tipo/tipo.texture = icon
	
	insert_attack(attacks)
	
		
func insert_attack(attacks: Array):	
	for attack in attacks:
		var attack_section = attack_redunction.instantiate()
		$"Efficenzy-container/VBoxContainer".add_child(attack_section)
		attack_section.attack_init_c(DB_Icons.load_icon(attack), "  "+attack)


func _on_button_pressed() -> void:
	$".".visible=false
