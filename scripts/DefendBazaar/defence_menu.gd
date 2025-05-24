extends Panel

var attack_redunction = preload("res://scenes/DefendBazaar/defence_attack_redunction.tscn")


var defence_id
var cost

func _physics_process(_delta: float) -> void:
	if $".".visible:
		if cost > $"../..".btc:
			$Info/Level/UpgradeButton.disabled = true
		else:
			$Info/Level/UpgradeButton.disabled = false




func open_menu(new_defence_id:int, new_type:String, icon:Resource, new_level:int, p_cost:int, attacks: Array):
	$".".visible=true
	defence_id=new_defence_id
	$"Info/Tipo/tipo-stat".text = new_type
	$Info/Tipo/tipo.texture = icon
	$Info/Level/level_stat.text = str(new_level)
	cost = p_cost
	$Info/Level/cost_stat.text = str(cost)+" ₿"
	
	insert_attack(new_type, attacks, new_level)
	
		
func insert_attack(new_type:String, attacks: Array, level):
	var defendBazaar=get_tree().current_scene
	
	for attack in attacks:
		var attack_section = attack_redunction.instantiate()
		$"Efficenzy-container/VBoxContainer".add_child(attack_section)
		attack_section.attack_init(DB_Icons.load_icon(attack), "  "+attack, defendBazaar.level.get_perc_redunction(attack, new_type, level-1))
