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


var base_critical_event_0day_percentage = 7 
var base_critical_event_social_percentage = 7 

var bonus_perc:=0
var bonus_damage:=0

var paths := []



var structures := []

var defence_buttons := []



var attacks_spawned := []
var n_level_playing = 1

var curve_to_router: Array

var level


var timer

var static_defence = [
	{
		"name": "Patch",
		"level": 0,
		"state": false,
		"remaining_wave": 0
	},
	{
		"name": "Phishing",
		"level": 0,
		"state": false,
		"remaining_wave": 0
	},
	{
		"name": "Antivirus",
		"level": 0,
		"state": false,
		"remaining_wave": 0
	}
]

signal critical_event_closed

func _ready():
	if Global.save_data["settings"]["crt"] == false:
		$CanvasLayer.visible = false
	$CriticalEvent.process_mode = Node.PROCESS_MODE_ALWAYS
	$AudioStreamPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	init_level(n_level_playing)

func _process(_delta: float) -> void:
	if timer!=null && timer.is_stopped() == false:
		$"SideBar/Status-container/Stat/WaveTimerSect/wave-timer-stat".text = str(int(timer.time_left)) + " s"
	if $WaveTimer!=null && $WaveTimer.is_stopped() == false:
		$"SideBar/Status-container/Stat/WaveTimerSect/wave-timer-stat".text = str(int($WaveTimer.time_left)) + " s"
	if $CriticalEvent/Critic0Day!=null && $CriticalEvent/Critic0Day.is_stopped() == false:
		$"CriticEffect-tim".text = str(int($CriticalEvent/Critic0Day.time_left)) + " s"
	if $CriticalEvent/CriticSocialEngeeniering!=null && $CriticalEvent/CriticSocialEngeeniering.is_stopped() == false:
		$"CriticEffect2-tim".text = str(int($CriticalEvent/CriticSocialEngeeniering.time_left)) + " s"

	if $PlayZone/StaticDefenceMenu!=null && $PlayZone/StaticDefenceMenu.visible == true:
		if $PlayZone/StaticDefenceMenu.type=="Patch":
			if btc>=level.static_defence[0].level_cost[static_defence[0]["level"]]:
				$PlayZone/StaticDefenceMenu/Info/Level/StaticUpgradeButton.disabled=false
			else:
				$PlayZone/StaticDefenceMenu/Info/Level/StaticUpgradeButton.disabled=true
			
			if btc>=level.static_defence[0].activation_cost:
				$PlayZone/StaticDefenceMenu/Info/State/VBoxContainer/Activate.disabled=false
			else:
				$PlayZone/StaticDefenceMenu/Info/State/VBoxContainer/Activate.disabled=true

		if $PlayZone/StaticDefenceMenu.type=="Phishing":
			if btc>=level.static_defence[1].level_cost[static_defence[1]["level"]]:
				$PlayZone/StaticDefenceMenu/Info/Level/StaticUpgradeButton.disabled=false
			else:
				$PlayZone/StaticDefenceMenu/Info/Level/StaticUpgradeButton.disabled=true
			
			if btc>=level.static_defence[1].activation_cost:
				$PlayZone/StaticDefenceMenu/Info/State/VBoxContainer/Activate.disabled=false
			else:
				$PlayZone/StaticDefenceMenu/Info/State/VBoxContainer/Activate.disabled=true
			
		if $PlayZone/StaticDefenceMenu.type=="Antivirus":
			if btc>=level.static_defence[2].level_cost[static_defence[2]["level"]]:
				$PlayZone/StaticDefenceMenu/Info/Level/StaticUpgradeButton.disabled=false
			else:
				$PlayZone/StaticDefenceMenu/Info/Level/StaticUpgradeButton.disabled=true

			if btc>=level.static_defence[2].activation_cost:
				$PlayZone/StaticDefenceMenu/Info/State/VBoxContainer/Activate.disabled=false
			else:
				$PlayZone/StaticDefenceMenu/Info/State/VBoxContainer/Activate.disabled=true



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
	
	update_static_defence(0, false, 0)
	update_static_defence(1, false, 0)
	update_static_defence(2, false, 0)

	
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
	if self.conf > new_conf:
		$"SideBar/Status-container/Stat/Conf/AnimationPlayer".play("error")
	$"SideBar/Status-container/Stat/Conf/conf-stat".text="["+"#".repeat(new_conf)+"-".repeat(10-new_conf)+"]" 
	self.conf = new_conf
	if self.integ > new_integ:
		$"SideBar/Status-container/Stat/Integ/AnimationPlayer".play("error")
	$"SideBar/Status-container/Stat/Integ/integ-stat".text="["+"#".repeat(new_integ)+"-".repeat(10-new_integ)+"]" 
	self.integ = new_integ
	if self.disp > new_disp:
		$"SideBar/Status-container/Stat/Disp/AnimationPlayer".play("error")
	$"SideBar/Status-container/Stat/Disp/disp-stat".text="["+"#".repeat(new_disp)+"-".repeat(10-new_disp)+"]" 
	self.disp = new_disp

func update_static_defence(index:int, state:bool, static_defence_level:int) -> void:
	if index == 0:
		if state==false:
			$SideBar/PassiveDef/Stat/Patch/Status.text = "❌ - [0]"
		else:
			$SideBar/PassiveDef/Stat/Patch/Status.text = "✅ - ["+str(static_defence[0]["remaining_wave"])+"]"
		$SideBar/PassiveDef/Stat/Patch/level.text = str(static_defence_level)+" - "+str(level.static_defence[0].level_cost[static_defence_level])+" ₿"
	if index == 1:
		if state==false:
			$SideBar/PassiveDef/Stat/SocialEngeneering/Status.text = "❌ - [0]"
		else:
			$SideBar/PassiveDef/Stat/SocialEngeneering/Status.text = "✅ - ["+str(static_defence[1]["remaining_wave"])+"]"
		$SideBar/PassiveDef/Stat/SocialEngeneering/level.text=str(static_defence_level)+" - "+str(level.static_defence[1].level_cost[static_defence_level])+" ₿"
	if index == 2:
		if state==false:
			$SideBar/PassiveDef/Stat/Antivirus/Status.text = "❌ - [0]"
		else:
			$SideBar/PassiveDef/Stat/Antivirus/Status.text = "✅ - ["+str(static_defence[2]["remaining_wave"])+"]"
		$SideBar/PassiveDef/Stat/Antivirus/level.text=str(static_defence_level)+" - "+str(level.static_defence[2].level_cost[static_defence_level])+" ₿"


func update_wave() -> void:
	$"SideBar/Status-container/Stat/Wave/wave-stat".text = str(wave)+"/"+str(len(level.waves)-1)

func update_minimap() -> void:
	var gameArea = load(level.minimap)
	$PlayZone/TextureRect.texture = gameArea

func update_btc() -> void:
	$"SideBar/Status-container/Stat/BTC/Btc-stat".text=str(btc)


#! TEMP FUNCTION
func game_level_up():
	$"SideBar/Status-container/Stat/BTC/BtcGen".stop()
	$PlayZone/BtcGen_stat/AnimationPlayer.play("RESET")
	n_level_playing += 1
	for i in defence_buttons:
		i.queue_free()
	init_level(n_level_playing)





func get_defence_other_info(type: String, defence_level: int) -> Array:
	var value = []
	if len(level.placable_defence_level_cost[type])-1<defence_level:
		value.append(0)
	else:
		value.append(level.get_upgrade_level_cost(type, defence_level))
	
	value.append(level.get_blocked_attack(type))
	value.append(len(level.placable_defence_level_cost[type])-1)
	return value

func _on_upgrade_button_pressed() -> void:
	var button
	for i in defence_buttons:
		if i.node_id==$"PlayZone/DefenceMenu".defence_id:
			button = i
			break
	button.upgrade()




func _on_button_pressed() -> void:
	$Close_menu.play()
	$PlayZone/DefenceMenu.visible=0


func _on_btc_gen_timeout() -> void:
	$"SideBar/Status-container/Stat/BTC/Coin".play()
	btc += 10
	update_btc()


var attack_spawn_position := [Vector2(230.0, 35), Vector2(347.0, 35), Vector2(480.0, 35)]

func start_wave() -> void:
	$"SideBar/Status-container/Stat/WaveTimerSect/wave-timer-label".text = "Fine ondata tra: "
	if $"SideBar/Status-container/Stat/BTC/BtcGen".paused==true:
		$"SideBar/Status-container/Stat/BTC/BtcGen".paused=false
	else:
		$"SideBar/Status-container/Stat/BTC/BtcGen".start()
	$PlayZone/BtcGen_stat/AnimationPlayer.play("btc_gen")
	$PlayZone/Attack/AttackSpawner.start()
	$WaveTimer.wait_time = level.waves[wave][0]
	$WaveTimer.start()
	$WaveTimer.next_wave_timer = level.waves[wave][1]
	_on_attack_spawner_timeout()
	$CriticalEventTimer.start()
	

func _on_wave_timer_timeout() -> void:
	$WaveTimer.stop()
	if $WaveTimer.next_wave_timer!=0:
		$PlayZone/Attack/AttackSpawner.stop()
		$"SideBar/Status-container/Stat/BTC/BtcGen".paused=true
		$PlayZone/BtcGen_stat/AnimationPlayer.pause()
		$CriticalEventTimer.stop()
		$CriticalEvent/CriticSocialEngeeniering.paused = true
		$CriticalEvent/Critic0Day.paused = true
		$"SideBar/Status-container/Stat/WaveTimerSect/wave-timer-label".text = "Inizio ondata tra: "
		$WaveTimer.wait_time=$WaveTimer.next_wave_timer
		$WaveTimer.next_wave_timer=0
		$WaveTimer.start()
	else:
		if wave+1 <= (len(level.waves)-1):
			wave += 1
			update_wave()
			start_wave()
			if $CriticalEvent/CriticSocialEngeeniering.paused == true:
				$CriticalEvent/CriticSocialEngeeniering.paused = false
			if $CriticalEvent/Critic0Day.paused == true:
				$CriticalEvent/Critic0Day.paused = false
			

			if static_defence[0]["remaining_wave"]>1:
				if btc>=level.static_defence[0].manteing_cost:
					btc-=level.static_defence[0].manteing_cost
					update_btc()
					static_defence[0]["remaining_wave"]-=1
					if $PlayZone/StaticDefenceMenu.type == "Patch":
						$PlayZone/StaticDefenceMenu.update_remaining_wave(static_defence[0]["remaining_wave"])
					update_static_defence(0, static_defence[0]["state"], static_defence[0]["level"])
				else:
					print("MALUS MANTENIMENTO PATCH") #! IMPLEMENTAZIONE DEI MALUS
					$PlayZone/StaticDefenceMenu.deactivate()
					static_defence[0]["remaining_wave"]=0
					static_defence[0]["state"]=false
					update_static_defence(0, static_defence[0]["state"], static_defence[0]["level"])
			elif static_defence[0]["remaining_wave"]==1 && $PlayZone/StaticDefenceMenu.type == "Patch":
				static_defence[0]["remaining_wave"]-=1
				static_defence[0]["state"]=false
				update_static_defence(0, static_defence[0]["state"], static_defence[0]["level"])
				$PlayZone/StaticDefenceMenu.deactivate()



			if static_defence[1]["remaining_wave"]>1:
				if btc>=level.static_defence[1].manteing_cost:
					btc-=level.static_defence[1].manteing_cost
					update_btc()
					static_defence[1]["remaining_wave"]-=1
					if $PlayZone/StaticDefenceMenu.type == "Phishing":
						$PlayZone/StaticDefenceMenu.update_remaining_wave(static_defence[1]["remaining_wave"])
					update_static_defence(1, static_defence[1]["state"], static_defence[1]["level"])
				else:
					print("MALUS MANTENIMENTO PHISHING") #! IMPLEMENTAZIONE DEI MALUS
					$PlayZone/StaticDefenceMenu.deactivate()
					static_defence[0]["remaining_wave"]=0
					static_defence[0]["state"]=false
					update_static_defence(1, static_defence[1]["state"], static_defence[1]["level"])
			elif static_defence[1]["remaining_wave"]==1 && $PlayZone/StaticDefenceMenu.type == "Phishing":
				static_defence[1]["remaining_wave"]-=1
				static_defence[1]["state"]=false
				update_static_defence(1, static_defence[1]["state"], static_defence[1]["level"])
				$PlayZone/StaticDefenceMenu.deactivate()


			if static_defence[2]["remaining_wave"]>1:
				if btc>=level.static_defence[2].manteing_cost:
					btc-=level.static_defence[2].manteing_cost
					update_btc()
					static_defence[2]["remaining_wave"]-=1
					if $PlayZone/StaticDefenceMenu.type == "Antivirus":
						$PlayZone/StaticDefenceMenu.update_remaining_wave(static_defence[2]["remaining_wave"])
					update_static_defence(2, static_defence[2]["state"], static_defence[2]["level"])
				else:
					print("MALUS MANTENIMENTO ANTIVIRUS") #! IMPLEMENTAZIONE DEI MALUS
					$PlayZone/StaticDefenceMenu.deactivate()
					static_defence[2]["remaining_wave"]=0
					static_defence[2]["state"]=false
					update_static_defence(2, static_defence[2]["state"], static_defence[2]["level"])
			elif static_defence[2]["remaining_wave"]==1 && $PlayZone/StaticDefenceMenu.type == "Antivirus":
				static_defence[2]["remaining_wave"]-=1
				static_defence[2]["state"]=false
				update_static_defence(2, static_defence[2]["state"], static_defence[2]["level"])
				$PlayZone/StaticDefenceMenu.deactivate()


		else:
			$WaveTimer.stop()
			#! inserire il game level up qui
			pass



func _on_attack_spawner_timeout() -> void:
	var spawn_position = randi_range(0, 2)
	var attacks = level.attacks
	var attack_type = attacks[randi_range(0, len(attacks)-1)]
	var new_attack = attack.instantiate()
	new_attack.set_attack(attack_type.attack_type, attack_type.succ_perc+bonus_perc-level.static_defence[2].effect[1][static_defence[2]["level"]] if static_defence[2]["state"]==true && $"CriticalEvent/CriticSocialEngeeniering".is_stopped()==false else attack_type.succ_perc+bonus_perc) 
	new_attack.position = attack_spawn_position[spawn_position]
	$PlayZone/Attack.add_child(new_attack)
	new_attack.start_following_curve(curve_to_router[spawn_position])
	attacks_spawned.append(new_attack)

func _on_router_body_entered(body: Node2D) -> void:
	if attacks_spawned.find(body)!=-1:
		var prefered_target = level.get_prefered_target(body.attack_type)
		var defined_paths = find_path(prefered_target)
		
		if len(defined_paths)!=0:
			var effective_defence = level.get_effective_defence(body.attack_type)
			var paths_with_defenses = []
			var paths_without_defenses = []

			for path_candidate in defined_paths:
				var path_has_defense = false
				for node in path_candidate:
					if effective_defence.has(node.type): 
						path_has_defense = true
						break
				if path_has_defense:
					paths_with_defenses.append(path_candidate)
				else:
					paths_without_defenses.append(path_candidate)

			var random_chance = randi_range(0, 99)
			var chosen_path 

			if random_chance < 70: # 70% di probabilità di scegliere un percorso con difese
				if len(paths_with_defenses) > 0:
					chosen_path = paths_with_defenses[randi_range(0, len(paths_with_defenses)-1)]
				elif len(paths_without_defenses) > 0: # Fallback: nessun percorso con difese, ne sceglie uno senza
					chosen_path = paths_without_defenses[randi_range(0, len(paths_without_defenses)-1)]
				# Se anche paths_without_defenses è vuoto, chosen_path rimarrà null, ma questo non dovrebbe accadere
				# se defined_paths non è vuoto, poiché ogni percorso definito dovrebbe cadere in una delle due categorie.
			else: # 30% di probabilità di scegliere un percorso senza difese
				if len(paths_without_defenses) > 0:
					chosen_path = paths_without_defenses[randi_range(0, len(paths_without_defenses)-1)]
				elif len(paths_with_defenses) > 0: # Fallback: nessun percorso senza difese, ne sceglie uno con
					chosen_path = paths_with_defenses[randi_range(0, len(paths_with_defenses)-1)]
			
			# chosen_path dovrebbe essere sempre assegnato qui se defined_paths non è vuoto.
			body.set_curve_to_follow(chosen_path)
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
			new_damage.append(damage[0]+bonus_damage if static_defence[2]["state"]==false else damage[0]+bonus_damage-level.static_defence[2].effect[0][static_defence[2]["level"]])
		else:
			new_damage.append(damage[0])
		if damage[1]!=0:
			new_damage.append(damage[1]+bonus_damage if static_defence[2]["state"]==false else damage[1]+bonus_damage-level.static_defence[2].effect[0][static_defence[2]["level"]])
		else:
			new_damage.append(damage[1])
		if damage[2]!=0:
			new_damage.append(damage[2]+bonus_damage if static_defence[2]["state"]==false else damage[2]+bonus_damage-level.static_defence[2].effect[0][static_defence[2]["level"]])
		else:
			new_damage.append(damage[2])

		if conf-new_damage[0]>=0 && integ-new_damage[1]>=0 && disp-new_damage[2]>=0:
			update_stat(conf-new_damage[0], integ-new_damage[1], disp-new_damage[2])
		else:
			print("GAME OVER")

func remove_attack(body: Node) -> void:
	for i in range(len(attacks_spawned) - 1, -1, -1): # Start from last index, go down to 0
		if attacks_spawned[i] == body:
			attacks_spawned.remove_at(i)
			# If you expect only one match, you can 'break' here
			break

func _on_defence_menu_visibility_changed() -> void:
	if $PlayZone/DefenceMenu.visible==false:
		for child in $"PlayZone/DefenceMenu/Efficenzy-container/VBoxContainer".get_children():
			child.queue_free()


func _on_critical_event_timeout() -> void:
	var perc = randi_range(1, 100)

	var zday_perc = base_critical_event_0day_percentage if static_defence[0].state == false else base_critical_event_0day_percentage-level.static_defence[0].effect[static_defence[0]["level"]]
	var soceng_perc = base_critical_event_social_percentage if static_defence[1].state == false else base_critical_event_social_percentage-level.static_defence[1].effect[static_defence[1]["level"]]
	var event
	var critical_event

	if perc <= zday_perc:
		if $CriticalEvent/Critic0Day.is_stopped() == false:
			return
		else:
			$CriticalEvent/Error.play()
			event = 0
			get_tree().paused = true
			var random_number_attack = randi_range(0, len(level.critical_events["0 day"])-1)
			critical_event = level.critical_events["0 day"][random_number_attack]
			$CriticalEvent/CriticalMenu/attack_type.text = critical_event.attack_name
			$CriticalEvent/CriticalMenu/Description.text = critical_event.description
			$CriticalEvent/CriticalMenu/conf_damage.text = "Confidenzialità: -"+str(critical_event.damage[0])
			$CriticalEvent/CriticalMenu/integ_damage.text = "Integrità: -"+str(critical_event.damage[1])
			$CriticalEvent/CriticalMenu/avaiab_damage.text = "Disponibilità: -"+str(critical_event.damage[2])
			$CriticalEvent/CriticalMenu/SideEffect_crit_stat.text = "gli attacchi avranno +"+str(critical_event.side_effect[0])+" di danno per i prossimi 10 secondi"
			bonus_damage = critical_event.side_effect[0]
	elif perc > zday_perc and perc <= soceng_perc+zday_perc:
		if $CriticalEvent/CriticSocialEngeeniering.is_stopped() == false:
			return
		else:
			$CriticalEvent/Error.play()
			event = 1
			get_tree().paused = true
			var random_number_attack = randi_range(0, len(level.critical_events["Social Engineering"])-1)
			critical_event = level.critical_events["Social Engineering"][random_number_attack]
			$CriticalEvent/CriticalMenu/attack_type.text = critical_event.attack_name
			$CriticalEvent/CriticalMenu/Description.text = critical_event.description
			$CriticalEvent/CriticalMenu/conf_damage.text = "Confidenzialità: -"+str(critical_event.damage[0])
			$CriticalEvent/CriticalMenu/integ_damage.text = "Integrità: -"+str(critical_event.damage[1])
			$CriticalEvent/CriticalMenu/avaiab_damage.text = "Disponibilità: -"+str(critical_event.damage[2])
			$CriticalEvent/CriticalMenu/SideEffect_crit_stat.text = "gli attacchi avranno +"+str(critical_event.side_effect[1])+" di vita per i prossimi 10 secondi"
			bonus_perc = critical_event.side_effect[1]
	if event==0 || event==1:
		$CriticalEvent/AnimationPlayer.play("critical appear")
		await critical_event_closed
		update_malus(event)
		if event==0:
			$CriticalEvent/Critic0Day.start()
		else:
			$CriticalEvent/CriticSocialEngeeniering.start()
			add_bonus_life()
		if conf-critical_event.damage[0]>=0 && integ-critical_event.damage[1]>=0 && disp-critical_event.damage[2]>=0:
			update_stat(conf-critical_event.damage[0], integ-critical_event.damage[1], disp-critical_event.damage[2])
		else:
			print("GAME OVER")

func _on_close_button_pressed() -> void:
	critical_event_closed.emit()
	get_tree().paused = false
	$Close_menu.play()
	$CriticalEvent/AnimationPlayer.play("RESET")


func _on_critic_0_day_timeout() -> void:
	bonus_damage = 0
	update_malus(3)


func _on_critic_social_engeeniering_timeout() -> void:
	remove_bonus_life()
	bonus_perc = 0
	update_malus(4)

func update_malus(type: int) -> void:
	if type==0: 
		$CriticEffect.text = "Danno: +"+str(bonus_damage)+" - tempo rimanente: "
	elif type==1:
		$CriticEffect2.text = "Vita: +"+str(bonus_perc)+" - tempo rimanente: "
	elif type ==3:
		$CriticEffect.text = ""
		$"CriticEffect-tim".text=""
	else:
		$CriticEffect2.text = ""
		$"CriticEffect2-tim".text = ""

var life_added

func add_bonus_life() -> void:
	if static_defence[2]["state"]==true:
		life_added = true
	else:
		life_added = false
	for current_attack in attacks_spawned:
		if is_instance_valid(current_attack):
			current_attack.life = current_attack.life+bonus_perc if static_defence[2]["state"]==false else current_attack.life+bonus_perc-level.static_defence[2].effect[1][static_defence[2]["level"]]
			current_attack.reload_life()

func remove_bonus_life() -> void:
	if life_added == true:
		for current_attack in attacks_spawned:
			if is_instance_valid(current_attack) && static_defence[2]["state"] == true && current_attack.life-bonus_perc+level.static_defence[2].effect[1][static_defence[2]["level"]] >=0:
				current_attack.life = current_attack.life-bonus_perc+level.static_defence[2].effect[1][static_defence[2]["level"]]
				current_attack.reload_life()
				continue
			if is_instance_valid(current_attack) and current_attack.life - bonus_perc >= 0:
				current_attack.life = current_attack.life-bonus_perc
				current_attack.reload_life()
				continue
			elif is_instance_valid(current_attack) and current_attack.life - bonus_perc < 0:
				current_attack.queue_free()





#* STATIC DEFENCE MENU

func _on_info_button_patch_pressed() -> void:
	if $PlayZone/StaticDefenceMenu.visible == false || $PlayZone/StaticDefenceMenu.type!="Patch":
		$PlayZone/StaticDefenceMenu.init_static_defence("Patch", "🩹", "Patch di sistema", static_defence[0]["state"], static_defence[0]["remaining_wave"], level.static_defence[0].activation_cost, level.static_defence[0].manteing_cost, static_defence[0]["level"], level.static_defence[0].level_cost[static_defence[0]["level"]], "La probabilità che si verifichi un evento 0 day è ridotta del ", level.static_defence[0].effect[static_defence[0]["level"]])
		$PlayZone/StaticDefenceMenu.open_menu()
	else:
		$PlayZone/StaticDefenceMenu.visible=false



func _on_info_button_social_eng_pressed() -> void:
	if $PlayZone/StaticDefenceMenu.visible == false || $PlayZone/StaticDefenceMenu.type!="Phishing":
		$PlayZone/StaticDefenceMenu.init_static_defence("Phishing", "🪝", "Corsi di formazione", static_defence[1]["state"], static_defence[1]["remaining_wave"], level.static_defence[1].activation_cost, level.static_defence[1].manteing_cost, static_defence[1]["level"], level.static_defence[1].level_cost[static_defence[1]["level"]], "La probabilità che si verifichi un evento Social Engineering è ridotta del ", level.static_defence[1].effect[static_defence[1]["level"]])
		$PlayZone/StaticDefenceMenu.open_menu()
	else:
		$PlayZone/StaticDefenceMenu.visible=false

func _on_info_button_antivirus_pressed() -> void:
	if $PlayZone/StaticDefenceMenu.visible == false || $PlayZone/StaticDefenceMenu.type!="Antivirus":
		$PlayZone/StaticDefenceMenu.init_static_defence("Antivirus", "🛡️", "Antivirus distribuiti", static_defence[2]["state"], static_defence[2]["remaining_wave"], level.static_defence[2].activation_cost, level.static_defence[2].manteing_cost, static_defence[2]["level"], level.static_defence[2].level_cost[static_defence[2]["level"]], "Gli effetti degli eventi critici sono ridotti. Riduzione aumento danno: £. Riduzione aumento vita: ", level.static_defence[2].effect)
		$PlayZone/StaticDefenceMenu.open_menu()
	else:
		$PlayZone/StaticDefenceMenu.visible=false


func _on_back_button_pressed() -> void:
	$Close_menu.play()
	$PlayZone/StaticDefenceMenu.visible = false



func _on_static_upgrade_button_pressed() -> void:
	if $PlayZone/StaticDefenceMenu.type=="Patch":
		btc-=level.static_defence[0].level_cost[static_defence[0]["level"]]
		update_btc()
		static_defence[0]["level"] += 1
		$PlayZone/StaticDefenceMenu.upgrade(static_defence[0]["level"], level.static_defence[0].level_cost[static_defence[0]["level"]], level.static_defence[0].effect[static_defence[0]["level"]])
		update_static_defence(0, static_defence[0]["state"], static_defence[0]["level"])
	elif $PlayZone/StaticDefenceMenu.type=="Phishing":
		btc-=level.static_defence[1].level_cost[static_defence[1]["level"]]
		update_btc()
		static_defence[1]["level"] += 1
		$PlayZone/StaticDefenceMenu.upgrade(static_defence[1]["level"], level.static_defence[1].level_cost[static_defence[1]["level"]], level.static_defence[1].effect[static_defence[1]["level"]])
		update_static_defence(1, static_defence[1]["state"], static_defence[1]["level"])
	else:
		btc-=level.static_defence[2].level_cost[static_defence[2]["level"]]
		update_btc()
		static_defence[2]["level"] += 1
		$PlayZone/StaticDefenceMenu.upgrade(static_defence[2]["level"], level.static_defence[2].level_cost[static_defence[2]["level"]], level.static_defence[2].effect[static_defence[2]["level"]])
		update_static_defence(2, static_defence[2]["state"], static_defence[2]["level"])


func _on_activate_pressed() -> void:
	if $PlayZone/StaticDefenceMenu.type=="Patch":
		if level.static_defence[0].activation_cost>btc:
			return
		$PlayZone/StaticDefenceMenu/Info/State/VBoxContainer/Activate/AudioStreamPlayer.play()
		btc-=level.static_defence[0].activation_cost
		update_btc()
		static_defence[0]["state"] = true
		static_defence[0]["remaining_wave"] = 3
		$PlayZone/StaticDefenceMenu.activate(3)
		update_static_defence(0, static_defence[0]["state"], static_defence[0]["level"])
	if $PlayZone/StaticDefenceMenu.type=="Phishing":
		if level.static_defence[1].activation_cost>btc:
			return
		$PlayZone/StaticDefenceMenu/Info/State/VBoxContainer/Activate/AudioStreamPlayer.play()
		btc-=level.static_defence[1].activation_cost
		update_btc()
		static_defence[1]["state"] = true
		static_defence[1]["remaining_wave"] = 3
		$PlayZone/StaticDefenceMenu.activate(3)
		update_static_defence(1, static_defence[1]["state"], static_defence[1]["level"])
	if $PlayZone/StaticDefenceMenu.type=="Antivirus":
		if level.static_defence[2].activation_cost>btc:
			return
		$PlayZone/StaticDefenceMenu/Info/State/VBoxContainer/Activate/AudioStreamPlayer.play()
		btc-=level.static_defence[2].activation_cost
		update_btc()
		static_defence[2]["state"] = true
		static_defence[2]["remaining_wave"] = 3
		$PlayZone/StaticDefenceMenu.activate(3)
		update_static_defence(2, static_defence[2]["state"], static_defence[2]["level"])

func open_def_builder_info(defence_type) -> void:
	$PlayZone/DefenceMenu_builder.open_menu(defence_type, DB_Icons.load_icon(defence_type), level.get_blocked_attack(defence_type))
