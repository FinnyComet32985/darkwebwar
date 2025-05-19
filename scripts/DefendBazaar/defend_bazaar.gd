extends Node

signal level_up_requested

var defence_button = preload("res://scenes/DefendBazaar/defence_button.tscn")
var attack = preload("res://scenes/DefendBazaar/Attack.tscn")
var structure = preload("res://scenes/DefendBazaar/primary_structure.tscn")

var conf := 0
var integ := 0
var disp := 0

var btc := 0


var paths := []



var structures := []

var defence_buttons := []


var defence_built := []


var attack_spawned := []
var n_level_playing = 1

var curve_to_router: Array


func _ready():
	if Global.save_data["settings"]["crt"] == false:
		$CanvasLayer.visible = false
	
	init_level(n_level_playing)
	connect("level_up_requested", Callable(self, "_on_level_up_requested"))


func init_level(n_level:int) -> void:
	var defence = get_node("PlayZone/Defence")
	var structure_area = get_node("PlayZone/Structure")
	
	
	var level = DB_Level_definer.get_level(n_level)
	
	paths = level.paths 


	$TerminalBar/StatusBar/Level.text = "Level "+str(n_level)
	$"SideBar/Status-container/Stat/Wave/wave-stat".text = "0/"+str(level.n_of_wave)
	update_stat(10, 10, 10)

	btc=10
	$"SideBar/Status-container/Stat/BTC/Btc-stat".text=str(btc)
	
	$SideBar/PassiveDef/Stat/Patch/Status.text = "❌ - [0]"
	$SideBar/PassiveDef/Stat/Patch/level.text = "0 - "+str(level.static_defence_level_cost["patch"][0])+" ₿"
	
	$SideBar/PassiveDef/Stat/Antivirus/Status.text = "❌ - [0]"
	$SideBar/PassiveDef/Stat/Antivirus/level.text="0 - "+str(level.static_defence_level_cost["antivirus"][0])+" ₿"
	
	$SideBar/PassiveDef/Stat/SocialEngeneering/Status.text = "❌ - [0]"
	$SideBar/PassiveDef/Stat/SocialEngeneering/level.text="0 - "+str(level.static_defence_level_cost["phishingRecognizer"][0])+" ₿"
	
	var gameArea = load(level.minimap)
	$PlayZone/TextureRect.texture = gameArea

	for path in level.paths:
		for node in path:
			if node.type=="defence":
				var button = defence_button.instantiate()
				button.position = node.position
				button.node_id = node.id
				defence.add_child(button)
				defence_buttons.append(button)
			elif node.type=="transaction_server" || node.type=="backend":
				var struct = structure.instantiate()
				struct.position = node.position
				struct.structure_type= node.type
				structure_area.add_child(struct)
				structures.append(struct)
				if node.type=="transaction_server":
						$PlayZone/BtcGen_stat.position = Vector2(node.position.x-42, node.position.y+45)

	$"SideBar/Status-container/Stat/BTC/BtcGen".start()
	$PlayZone/BtcGen_stat/AnimationPlayer.play("btc_gen")

	var curve_to_router_0 = Curve2D.new()
	curve_to_router_0.add_point(Vector2(249.0, 101.0))
	curve_to_router_0.add_point(Vector2(372.0, 224.0))
	curve_to_router.append(curve_to_router_0)

	var curve_to_router_1 = Curve2D.new()
	curve_to_router_1.add_point(Vector2(378.0, 97.0))
	curve_to_router_1.add_point(Vector2(378.0, 215.0))
	curve_to_router.append(curve_to_router_1)


	var curve_to_router_2 = Curve2D.new()
	curve_to_router_2.add_point(Vector2(507.0, 102.0))
	curve_to_router_2.add_point(Vector2(393.0, 215.0))
	curve_to_router.append(curve_to_router_2)

	
	start_wave()

func update_stat(new_conf, new_integ, new_disp) -> void:
	$"SideBar/Status-container/Stat/Conf/conf-stat".text="["+"#".repeat(new_conf)+"-".repeat(10-new_conf)+"]" 
	self.conf = new_conf
	$"SideBar/Status-container/Stat/Integ/integ-stat".text="["+"#".repeat(new_integ)+"-".repeat(10-new_integ)+"]" 
	self.integ = new_integ
	$"SideBar/Status-container/Stat/Disp/disp-stat".text="["+"#".repeat(new_disp)+"-".repeat(10-new_disp)+"]" 
	self.disp = new_disp


func _on_level_up_requested():
	$"SideBar/Status-container/Stat/BTC/BtcGen".stop()
	$PlayZone/BtcGen_stat/AnimationPlayer.play("RESET")
	n_level_playing += 1
	for i in defence_buttons:
		i.queue_free()
	init_level(n_level_playing)



func request_level_up():
	emit_signal("level_up_requested")


func get_defence_other_info(type: String, defence_level: int) -> Array:
	var level = DB_Level_definer.get_level(n_level_playing)
	var value = []
	value.append(level.get_upgrade_level_cost(type, defence_level))
	value.append(level.get_blocked_attack(type))
	
	return value



func update_btc() -> void:
	$"SideBar/Status-container/Stat/BTC/Btc-stat".text=str(btc)

	
func _on_upgrade_button_pressed() -> void:
	var button
	for i in defence_buttons:
		if i.type==$"PlayZone/DefenceMenu/Info/Tipo/tipo-stat".text:
			button = i
			break
	button.upgrade()


func _on_button_pressed() -> void:
	$PlayZone/DefenceMenu.visible=0


func _on_btc_gen_timeout() -> void:
	btc += 10
	update_btc()


var attack_spawn_position := [Vector2(230.0, 35), Vector2(347.0, 35), Vector2(480.0, 35)]

func start_wave() -> void:
	$PlayZone/Attack/AttackSpawner.start()


func _on_attack_spawner_timeout() -> void:
	var numero_random = randi_range(0, 2)
	var new_attack = attack.instantiate()
	new_attack.position = attack_spawn_position[numero_random]
	$PlayZone/Attack.add_child(new_attack)
	new_attack.start_following_curve(curve_to_router[numero_random])
	attack_spawned.append(new_attack)


func _on_router_body_entered(body: Node2D) -> void:
	if attack_spawned.find(body)!=-1:
		var prefered_target = DB_Level_definer.get_prefered_target(n_level_playing, body.attack_type)
		var defined_paths = find_path(prefered_target)
		
		if len(defined_paths)!=0:
			var effective_defence = DB_Level_definer.get_effective_defence(n_level_playing, body.attack_type)
			var excluded_paths = []

			for defence in effective_defence:
				for path in defined_paths:
					for node in path:
						if node.type== defence:
							excluded_paths.append(path)

			var optimal_paths = []
			for path in defined_paths:
				if not excluded_paths.has(path):
					optimal_paths.append(path)
			
			if len(optimal_paths)==0:
				body.set_curve_to_follow(defined_paths[randi_range(0, len(defined_paths)-1)])
			elif len(optimal_paths)==1:
				body.set_curve_to_follow(optimal_paths[0])
			else:
				body.set_curve_to_follow(optimal_paths[randi_range(0, len(optimal_paths)-1)])
		else:
			body.queue_free()
			return


func find_path(structure_names:Array) -> Array:
	var return_path = []
	for structure_name in structure_names: 
		var structure_name_c = structure_name+"_c"
		for path in paths:
			for node in path:
				if node.type == structure_name || node.type==structure_name_c:
					return_path.append(path)
	return return_path

func update_damage(attack_type, structure_type) -> void:
	var damage = DB_Level_definer.get_damage(n_level_playing, attack_type, structure_type)
	if len(damage)!=0:
		if conf-damage[0]>=0 && integ-damage[1]>=0 && disp-damage[2]>=0:
			update_stat(conf-damage[0], integ-damage[1], disp-damage[2])
		else:
			print("GAME OVER")
