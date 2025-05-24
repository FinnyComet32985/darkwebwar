extends HBoxContainer

var defence_type: String
var build_cost: int

func _physics_process(_delta: float) -> void:
	if $".".visible==true:
		if get_tree().current_scene.btc>=build_cost:
			$Build.disabled=false
		else:
			$Build.disabled=true




func init_element() -> void:
	$TextureRect.texture= DB_Icons.load_icon(defence_type)
	$"tipo-stat".text=defence_type
	$Cost.text=str(build_cost)+" ₿"

func _on_build_pressed() -> void:
	var defendBazaar=get_tree().current_scene
	defendBazaar.btc-=defendBazaar.get_defence_other_info(defence_type, 0)[0]
	defendBazaar.update_btc()
	$"../../../".defence_button.set_type(defence_type)
	$"../../../".defence_button.update_path()
	$"../../../".visible=0
