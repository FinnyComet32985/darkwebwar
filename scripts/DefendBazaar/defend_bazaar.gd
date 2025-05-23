extends Node

var defence_button = preload("res://scenes/DefendBazaar/defence_button.tscn")
var attack = preload("res://scenes/DefendBazaar/Attack.tscn")
var structure = preload("res://scenes/DefendBazaar/primary_structure.tscn")
var element_defence_builder = preload("res://scenes/DefendBazaar/defence_builder_elements.tscn")


var wave:= 0

var conf := 0
var integ := 0
var disp := 0

var btc := 0

var critical_event_percentage = 5

var bonus_perc:=0
var bonus_damage:=0

var paths := []



var structures := []

var defence_buttons := []



var attack_spawned := []
var n_level_playing = 1

var curve_to_router: Array

var level


var timer
signal critical_event_closed

func _ready():
	if Global.save_data["settings"]["crt"] == false:
		$CanvasLayer.visible = false
	$CriticalEvent.process_mode = Node.PROCESS_MODE_ALWAYS
	
	init_level(n_level_playing)

func _physics_process(delta: float) -> void:
	if timer!=null && timer.is_stopped() == false:
		$"SideBar/Status-container/Stat/WaveTimerSect/wave-timer-stat".text = str(int(timer.time_left)) + " s"
	if $WaveTimer!=null && $WaveTimer.is_stopped() == false:
		$"SideBar/Status-container/Stat/WaveTimerSect/wave-timer-stat".text = str(int($WaveTimer.time_left)) + " s"



func init_level(n_level:int) -> void:
	var defence_area = get_node("PlayZone/Defence")
	var structure_area = get_node("PlayZone/Structure")
	var defence_builder_area = get_node("PlayZone/DefenceBuilder/ScrollContainer/defence")
	
	
	level = DB_Level_definer.get_level(n_level)
	
	paths = level.paths 


	$TerminalBar/StatusBar/Level.text = "Level "+str(n_level)
	update_wave()
	update_stat(10, 10, 10)

	btc=10
	update_btc()
	


	#TODO refactor
	$SideBar/PassiveDef/Stat/Patch/Status.text = "❌ - [0]"
	$SideBar/PassiveDef/Stat/Patch/level.text = "0 - "+str(level.static_defence_level_cost["patch"][0])+" ₿"
	
	$SideBar/PassiveDef/Stat/Antivirus/Status.text = "❌ - [0]"
	$SideBar/PassiveDef/Stat/Antivirus/level.text="0 - "+str(level.static_defence_level_cost["antivirus"][0])+" ₿"
	
	$SideBar/PassiveDef/Stat/SocialEngeneering/Status.text = "❌ - [0]"
	$SideBar/PassiveDef/Stat/SocialEngeneering/level.text="0 - "+str(level.static_defence_level_cost["phishingRecognizer"][0])+" ₿"
	
	update_minimap()

	for path in level.paths:
		for node in path:				
			if node.type=="defence":
				var button = defence_button.instantiate()
				button.position = node.position
				button.node_id = node.id
				defence_area.add_child(button)
				defence_buttons.append(button)
			elif len(node.type)>=2:
				if node.type[len(node.type)-2]!="_":
					var struct = structure.instantiate()
					struct.position = node.position
					struct.structure_type= node.type
					structure_area.add_child(struct)
					structures.append(struct)
					if node.type=="transaction_server":
							$PlayZone/BtcGen_stat.position = Vector2(node.position.x-42, node.position.y+45)

	var defences = level.placable_defence_level_cost.keys()
	for defence in defences:
		var defence_element = element_defence_builder.instantiate()
		defence_element.defence_type = defence
		defence_element.build_cost = level.placable_defence_level_cost[defence][0]
		defence_element.init_element()
		defence_builder_area.add_child(defence_element)



	# set curve to router
	var curve_to_router_0 = Curve2D.new()
	curve_to_router_0.add_point(Vector2(249.0, 101.0))
	curve_to_router_0.add_point(Vector2(372.0, 224.0))
	curve_to_router.append(curve_to_router_0)

	var curve_to_router_1 = Curve2D.new()
	curve_to_router_1.add_point(Vector2(380.0, 97.0))
	curve_to_router_1.add_point(Vector2(380.0, 215.0))
	curve_to_router.append(curve_to_router_1)


	var curve_to_router_2 = Curve2D.new()
	curve_to_router_2.add_point(Vector2(507.0, 102.0))
	curve_to_router_2.add_point(Vector2(393.0, 215.0))
	curve_to_router.append(curve_to_router_2)

	if wave == 0:
		$"SideBar/Status-container/Stat/WaveTimerSect/wave-timer-label".text = "Inizio ondata tra: "
		timer = Timer.new()
		timer.wait_time = level.waves[wave][1]
		$".".add_child(timer)
		timer.start()
		await timer.timeout
		
		wave+=1
		update_wave()
		start_wave()
	else:
		start_wave()




#* UPDATE FUNCTIONS

func update_stat(new_conf, new_integ, new_disp) -> void:
	$"SideBar/Status-container/Stat/Conf/conf-stat".text="["+"#".repeat(new_conf)+"-".repeat(10-new_conf)+"]" 
	self.conf = new_conf
	$"SideBar/Status-container/Stat/Integ/integ-stat".text="["+"#".repeat(new_integ)+"-".repeat(10-new_integ)+"]" 
	self.integ = new_integ
	$"SideBar/Status-container/Stat/Disp/disp-stat".text="["+"#".repeat(new_disp)+"-".repeat(10-new_disp)+"]" 
	self.disp = new_disp

func update_wave() -> void:
	$"SideBar/Status-container/Stat/Wave/wave-stat".text = str(wave)+"/"+str(len(level.waves)-1)

func update_minimap() -> void:
	var gameArea = load(level.minimap)
	$PlayZone/TextureRect.texture = gameArea

func update_btc() -> void:
	$"SideBar/Status-container/Stat/BTC/Btc-stat".text=str(btc)



func game_level_up():
	$"SideBar/Status-container/Stat/BTC/BtcGen".stop()
	$PlayZone/BtcGen_stat/AnimationPlayer.play("RESET")
	n_level_playing += 1
	for i in defence_buttons:
		i.queue_free()
	init_level(n_level_playing)





func get_defence_other_info(type: String, defence_level: int) -> Array:
	var value = []
	value.append(level.get_upgrade_level_cost(type, defence_level))
	value.append(level.get_blocked_attack(type))
	return value




#! TEMP FUNCTION
func _on_upgrade_button_pressed() -> void:
	var button
	for i in defence_buttons:
		if i.node_id==$"PlayZone/DefenceMenu".defence_id:
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
	$"SideBar/Status-container/Stat/WaveTimerSect/wave-timer-label".text = "Fine ondata tra: "
	$"SideBar/Status-container/Stat/BTC/BtcGen".start()
	$PlayZone/BtcGen_stat/AnimationPlayer.play("btc_gen")
	$PlayZone/Attack/AttackSpawner.start()
	$WaveTimer.wait_time = level.waves[wave][0]
	$WaveTimer.start()
	$WaveTimer.next_wave_timer = level.waves[wave][1]
	_on_attack_spawner_timeout()
	$CriticalEventTimer.start()
	

func _on_wave_timer_timeout() -> void:
	if $WaveTimer.next_wave_timer!=0:
		$PlayZone/Attack/AttackSpawner.stop()
		$WaveTimer.stop()
		await $"SideBar/Status-container/Stat/BTC/BtcGen".timeout
		$"SideBar/Status-container/Stat/BTC/BtcGen".stop()
		$PlayZone/BtcGen_stat/AnimationPlayer.play("RESET")
		$CriticalEventTimer.stop()
		$"SideBar/Status-container/Stat/WaveTimerSect/wave-timer-label".text = "Inizio ondata tra: "
		$WaveTimer.wait_time=$WaveTimer.next_wave_timer
		$WaveTimer.next_wave_timer=0
		$WaveTimer.start()
	else:
		$WaveTimer.stop()
		if wave+1 <= (len(level.waves)-1):
			wave += 1
			update_wave()
			start_wave()
		else:
			$WaveTimer.stop()
			#! inserire il game level up qui
			pass



func _on_attack_spawner_timeout() -> void:
	var spawn_position = randi_range(0, 2)
	var attacks = level.attacks
	var attack_type = attacks[randi_range(0, len(attacks)-1)]
	var new_attack = attack.instantiate()
	new_attack.set_attack(attack_type.attack_type, attack_type.succ_perc) 
	new_attack.position = attack_spawn_position[spawn_position]
	$PlayZone/Attack.add_child(new_attack)
	new_attack.start_following_curve(curve_to_router[spawn_position])
	attack_spawned.append(new_attack)


func _on_router_body_entered(body: Node2D) -> void:
	if attack_spawned.find(body)!=-1:
		var prefered_target = level.get_prefered_target(body.attack_type)
		var defined_paths = find_path(prefered_target)
		
		if len(defined_paths)!=0:
			var effective_defence = level.get_effective_defence(body.attack_type)
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
	var damage = level.get_damage(attack_type, structure_type)

	if len(damage)!=0:
		var new_damage := []
		if damage[0]!=0:
			new_damage.append(damage[0]+bonus_damage)
		else:
			new_damage.append(damage[0])
		if damage[1]!=0:
			new_damage.append(damage[1]+bonus_damage)
		else:
			new_damage.append(damage[1])
		if damage[2]!=0:
			new_damage.append(damage[2]+bonus_damage)
		else:
			new_damage.append(damage[2])

		if conf-new_damage[0]>=0 && integ-new_damage[1]>=0 && disp-new_damage[2]>=0:
			update_stat(conf-new_damage[0], integ-new_damage[1], disp-new_damage[2])
		else:
			print("GAME OVER")


func _on_defence_menu_visibility_changed() -> void:
	if $PlayZone/DefenceMenu.visible==false:
		for child in $"PlayZone/DefenceMenu/Efficenzy-container/VBoxContainer".get_children():
			child.queue_free()


func _on_critical_event_timeout() -> void:
	var perc = randi_range(1, 100)
	if perc <=critical_event_percentage:
		get_tree().paused = true
		var random_number = randi_range(0, 1)
		var critical_event
		if random_number==0:
			random_number = randi_range(0, len(level.critical_events["0 day"])-1)
			critical_event = level.critical_events["0 day"][random_number]
			$CriticalEvent/CriticalMenu/attack_type.text = critical_event.attack_name
			$CriticalEvent/CriticalMenu/Description.text = critical_event.description
			$CriticalEvent/CriticalMenu/conf_damage.text = "Confidenzialità: -"+str(critical_event.damage[0])
			$CriticalEvent/CriticalMenu/integ_damage.text = "Integrità: -"+str(critical_event.damage[1])
			$CriticalEvent/CriticalMenu/avaiab_damage.text = "Avaiabilità: -"+str(critical_event.damage[2])
			$CriticalEvent/CriticalMenu/SideEffect_crit_stat.text = "gli attacchi avranno +"+str(critical_event.side_effect[0])+" di danno per i prossimi 10 secondi"
			bonus_damage = critical_event.side_effect[0]
			$CriticalEvent/Critic0Day.start()
			update_stat(conf-critical_event.damage[0], integ-critical_event.damage[1], disp-critical_event.damage[2])
		else:
			random_number = randi_range(0, len(level.critical_events["Social Engineering"])-1)
			critical_event = level.critical_events["Social Engineering"][random_number]
			$CriticalEvent/CriticalMenu/attack_type.text = critical_event.attack_name
			$CriticalEvent/CriticalMenu/Description.text = critical_event.description
			$CriticalEvent/CriticalMenu/conf_damage.text = "Confidenzialità: -"+str(critical_event.damage[0])
			$CriticalEvent/CriticalMenu/integ_damage.text = "Integrità: -"+str(critical_event.damage[1])
			$CriticalEvent/CriticalMenu/avaiab_damage.text = "Avaiabilità: -"+str(critical_event.damage[2])
			$CriticalEvent/CriticalMenu/SideEffect_crit_stat.text = "gli attacchi avranno +"+str(critical_event.side_effect[0])+" di vita per i prossimi 10 secondi"
			bonus_perc = critical_event.side_effect[1]
			$CriticalEvent/CriticSocialEngeeniering.start()
		$CriticalEvent/AnimationPlayer.play("critical appear")
		await critical_event_closed
		if conf-critical_event.damage[0]>=0 && integ-critical_event.damage[1]>=0 && disp-critical_event.damage[2]>=0:
			update_stat(conf-critical_event.damage[0], integ-critical_event.damage[1], disp-critical_event.damage[2])
		else:
			print("GAME OVER")

func _on_close_button_pressed() -> void:
	critical_event_closed.emit()
	get_tree().paused = false
	$CriticalEvent/AnimationPlayer.play("RESET")


func _on_critic_0_day_timeout() -> void:
	bonus_damage = 0


func _on_critic_social_engeeniering_timeout() -> void:
	bonus_perc = 0
