extends Panel

var attack_redunction = preload("res://scenes/DefendBazaar/defence_attack_redunction.tscn")


var defence_id
var level

func open_menu(new_defence_id:int, new_type:String, icon:Resource, new_level:int, cost:int, attacks: Array):
	$".".visible=true
	defence_id=new_defence_id
	$"Info/Tipo/tipo-stat".text = new_type
	$Info/Tipo/tipo.texture = icon
	level=new_level
	$Info/Level/level_stat.text = str(level)
	$Info/Level/cost_stat.text = str(cost)+" ₿"
	if cost > $"../..".btc:
		$Info/Level/UpgradeButton.visible = false
	
	for attack in attacks:
			var attack_section = attack_redunction.instantiate()
			$"Efficenzy-container/VBoxContainer".add_child(attack_section)
			attack_section.attack_init(DB_Icons.load_icon(attack), "  "+attack)
			
