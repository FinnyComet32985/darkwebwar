extends Panel
var type: String
var static_defence_type: String
var static_defence_name: String
var state: bool
var remaining_wave: int
var activation_cost: int
var manteing_cost: int
var level: int
var upgrade_cost:int 
var effect_description: String
var effect

func init_static_defence(p_type:String, p_static_defence_type: String, p_name: String, p_state: bool, p_remaining_wave: int, p_activation_cost: int, p_manteing_cost: int, p_level: int, p_upgrade_cost: int, p_effect_description: String, p_effect) -> void:
	type = p_type
	static_defence_type = p_static_defence_type
	static_defence_name = p_name
	state = p_state
	remaining_wave = p_remaining_wave
	activation_cost = p_activation_cost
	manteing_cost = p_manteing_cost
	level = p_level
	upgrade_cost = p_upgrade_cost
	effect_description = p_effect_description
	effect = p_effect


func open_menu() -> void:
	$"./Info/Tipo/tipo".text = static_defence_type
	$"./Info/Tipo/tipo-stat".text = static_defence_name
	$"./Info/State/VBoxContainer/state_stat".text = "❌ - [0]" if state == false else "✅ - ["+str(remaining_wave)+"]"
	$Info/State/VBoxContainer2/HBoxContainer/cost_stat.text = str(activation_cost)
	$Info/State/VBoxContainer2/HBoxContainer2/cost_stat.text = str(manteing_cost)
	$Info/Level/level_stat.text = str(level)
	$Info/Level/cost_stat.text = str(upgrade_cost)
	if effect is Array:
		var i = effect_description.find("£")
		var part1 = effect_description.substr(0, i-1)
		var part2 = effect_description.substr(i+1)
		$"Info/VBoxContainer/Effect-stat".text = part1+str(effect[0][level])+part2+str(effect[1][level])+"%" 
	else:
		$"Info/VBoxContainer/Effect-stat".text = effect_description+str(effect)+"%" 
	if state == true || level==0:
		$Info/State/VBoxContainer/Activate.visible = false
	else:
		$Info/State/VBoxContainer/Activate.visible = true
	$".".visible = true

func upgrade(p_level, p_upgrade_cost, p_effect) -> void:
	level = p_level
	upgrade_cost = p_upgrade_cost
	effect = p_effect
	$Info/Level/level_stat.text = str(level)
	$Info/Level/cost_stat.text = str(upgrade_cost) 
	if effect is Array:
		var i = effect_description.find("£")
		var part1 = effect_description.substr(0, i-1)
		var part2 = effect_description.substr(i+1)
		$"Info/VBoxContainer/Effect-stat".text = part1+str(effect[0])+part2+str(effect[1])+"%" 
	else:
		$"Info/VBoxContainer/Effect-stat".text = effect_description+str(effect)+"%"    
	if level-1==0:
		$Info/State/VBoxContainer/Activate.visible = true
	
func activate(p_remaining_wave) -> void:
	remaining_wave=p_remaining_wave
	$Info/State/VBoxContainer/state_stat.text = "✅ - ["+str(remaining_wave)+"]"
	state = true
	remaining_wave = remaining_wave
	$Info/State/VBoxContainer/Activate.visible=false

func deactivate() -> void:
	$Info/State/VBoxContainer/state_stat.text = "❌ - [0]"
	state = false
	remaining_wave = 0
	$Info/State/VBoxContainer/Activate.visible=true

func update_remaining_wave(p_remaining_wave) -> void:
	remaining_wave = p_remaining_wave
	$Info/State/VBoxContainer/state_stat.text = "✅ - ["+str(remaining_wave)+"]"
