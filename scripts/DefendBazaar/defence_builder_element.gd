extends HBoxContainer

var defence_type: String
var build_cost: int

func init_element() -> void:
	var icon
	match defence_type:
		"Firewall": 
			icon = preload("res://assets/DefendBazaar/defences/DarkWebWar-Firewall.svg")
		"WAF":
			icon = preload("res://assets/DefendBazaar/defences/DarkWebWar-WAF.svg")
		"IDS":
			icon = preload("res://assets/DefendBazaar/defences/DarkWebWar-IDS.svg")
		"Rate Limiter":
			icon = preload("res://assets/DefendBazaar/defences/DarkWebWar-RateLimiter.svg")
		_:
			print("error loading icon")
	$TextureRect.texture=icon
	$"tipo-stat".text=defence_type
	$Cost.text=str(build_cost)+" ₿"

func _on_build_pressed() -> void:
	var defendBazaar=get_tree().current_scene
	defendBazaar.btc-=defendBazaar.get_defence_other_info(defence_type, 0)[0]
	defendBazaar.update_btc()
	$"../../../".defence_button.set_type(defence_type)
	$"../../../".defence_button.update_path()
	$"../../../".visible=0


func set_build_button() -> void:
	var defendBazaar=get_tree().current_scene
	if defendBazaar.btc >= build_cost:
		$Build.visible = true
	else:
		$Build.visible = false
