extends Control

var n_level:= 0
var level
var next_word_id := 0 

var word_scene = preload("res://scenes/RithmForce/word.tscn")
var words_instantiated := []
var possible_word: Array
var spawn_position: Array = [
	[140, false],
	[240, false],
	[340, false],
	[440, false],
	[540, false],
	[640, false],
	[740, false],
	[840, false]
]

var perc_comp:= 0
var streak:= 0
var powerUP:= [ 0, 0, 0]
var speed_dec:=0
var shield:= false

var prev_word:= ""

func _process(_delta: float) -> void:
	if $GameTimer!=null and $GameTimer.is_stopped() == false:
		$"Stats/RemTime-stat".text = str(int($GameTimer.time_left))


func _ready() -> void:
	$Captcha.process_mode = Node.PROCESS_MODE_ALWAYS
	$AudioStreamPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	init_level()
	$LineEdit.grab_focus()



func init_level() -> void:
	$StatusBar/Level.text = "LEVEL " + str(n_level+1)
	$"Stats/PercComp-stat".text = str(perc_comp) + "%  [----------]"
	level = RF_Level_definer.levels[n_level]
	$GameTimer.wait_time = level.level_max_time
	$SpawnerTimer.wait_time = level.spawn_rate
	possible_word = level.dictionary.keys()
	await get_tree().create_timer(5).timeout
	$GameTimer.start()
	_on_spawner_timer_timeout()
	$SpawnerTimer.start()
	$CriticEventsTimer.start()


func _on_game_timer_timeout() -> void:
	$GameTimer.stop()
	$SpawnerTimer.stop()
	print("GAME OVER")

func _on_spawner_timer_timeout() -> void:
	if possible_word.is_empty():
		print("Parole finite")
		return

	var available_spawn_slots_references = []
	for slot_data in spawn_position:
		if not slot_data[1]: 
			available_spawn_slots_references.append(slot_data) 

	if available_spawn_slots_references.is_empty():
		print("Nessun punto di spawn disponibile.")
		return

	var word_instantiated = word_scene.instantiate()
	word_instantiated.id = next_word_id
	next_word_id += 1
	var chosen_slot_reference = available_spawn_slots_references[randi_range(0, available_spawn_slots_references.size() - 1)]
	word_instantiated.position.x = chosen_slot_reference[0] 
	chosen_slot_reference[1] = true

	word_instantiated.fall_speed = level.fall_speed-speed_dec
	var word_text = possible_word[randi_range(0, possible_word.size()-1)] 
	word_instantiated.word_text = word_text
	word_instantiated.difficulty = level.dictionary[word_text]
	possible_word.erase(word_text)
	
	words_instantiated.append(word_instantiated)
	$GameArea/Words.add_child(word_instantiated)


func _on_end_game_area_body_entered(body: Node2D) -> void:
	for pos in spawn_position:
		if pos[0] == body.position.x:
			pos[1] = false

	if body is CharacterBody2D and words_instantiated.has(body):
		if shield==true:
			shield=false
			$"PU/ShieldPU/ShieldTimer-sec/AnimationPlayer".play("cooldown")
			$PU/ShieldPU/ShieldCooldown.start()
		else:
			match body.difficulty:
				1:
					if perc_comp-5>=0:
						perc_comp-=5
						$"Stats/PercComp-stat".text = str(perc_comp) + " %  [" + "#".repeat(int(perc_comp/10))+ "-".repeat(10-int(perc_comp/10)) + "]"
					else:
						game_over()
		words_instantiated.erase(body)
	$Error.play()
	await body.destruct()
	body.queue_free()

func _on_line_edit_text_changed(new_text: String) -> void:
	for word_instantiated in words_instantiated:
		var text = word_instantiated.word_text
		if text.begins_with(new_text):
			word_instantiated.set_text("[color=green]" + new_text + "[/color]" + text.substr(new_text.length()))
			if prev_word == "":
				prev_word = text
		else:
			word_instantiated.set_text(text)
	if prev_word == "":
		for i in range(len(new_text)):
			var tmp = ""
			var instantiated = ""
			for j in range(len(new_text)):
				if i!=j:
					tmp+=new_text[j]
			for word_instantiated in words_instantiated:
				for j in range(len(word_instantiated.word_text)):
					if i!=j:
						instantiated+=word_instantiated.word_text[j]
				if tmp == instantiated:
					prev_word=word_instantiated.word_text
					break
				instantiated=""



var temp_streak:= 0

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == ":1":
		_on_overclock_pressed()
		$LineEdit.text = ""
		return
	if new_text == ":2":
		_on_shield_pressed()
		$LineEdit.text = ""
		return
	var finded:= false
	for word_instantiated in words_instantiated:
		var text = word_instantiated.word_text
		if text == new_text:
			for pos in spawn_position:
				if word_instantiated.position.x == pos[0]:
					pos[1] = false
			match  word_instantiated.difficulty:
				1: 
					if perc_comp+5<100:
						$Correct.play()
						perc_comp+=5
						$"Stats/PercComp-stat".text = str(perc_comp) + " %  [" + "#".repeat(int(perc_comp/10))+ "-".repeat(10-int(perc_comp/10)) + "]"
					else:
						reset_level()
						win_level()
						return
				2:
					if perc_comp+10<100:
						perc_comp+=10
						$Correct.play()
						$"Stats/PercComp-stat".text = str(perc_comp) + " %  [" + "#".repeat(int(perc_comp/10))+ "-".repeat(10-int(perc_comp/10)) + "]"
					else:
						reset_level()
						win_level()
						return
			words_instantiated.erase(word_instantiated)
			word_instantiated.queue_free()
			$LineEdit/AnimationPlayer.play("success")
			$Stats/AnimationPlayer.play("correct")
			$LineEdit.text = ""
			finded = true
			streak+=1
			$"Stats/Streak-stat".text=str(streak)
			temp_streak+=1
			match temp_streak:
				3:
					powerUP[0]+=1
					$PU/OverclockPU/Panel/OverclockLabel.text= str(powerUP[0])
				5:
					powerUP[1]+=1
					$PU/ShieldPU/Panel/ShieldLabel.text= str(powerUP[1])
				7:
					powerUP[2]+=1
					$PU/BypassPU/Panel/BypassLabel.text= str(powerUP[2])
					temp_streak=0
			break

	if finded==false:
		if level.dictionary.has(prev_word):
			for word_instantiated in words_instantiated:
				if word_instantiated.word_text == prev_word:
					for pos in spawn_position:
						if word_instantiated.position.x == pos[0]:
							pos[1] = false
			if shield==true:
				shield=false
				$PU/ShieldPU/ShieldCooldown.start()
				$"PU/ShieldPU/ShieldTimer-sec/AnimationPlayer".play("cooldown")
			else:
				match level.dictionary[prev_word]:
					1:
						if perc_comp-5>=0:
							perc_comp-=5
							$"Stats/PercComp-stat".text = str(perc_comp) + " %  [" + "#".repeat(int(perc_comp/10))+ "-".repeat(10-int(perc_comp/10)) + "]"
						else:
							game_over()
							return
		else:
			if shield==true:
				shield=false
				$PU/ShieldPU/ShieldCooldown.start()
				$"PU/ShieldPU/ShieldTimer-sec/AnimationPlayer".play("cooldown")
			else:
				if perc_comp-5>=0:
					perc_comp-=5
					$"Stats/PercComp-stat".text = str(perc_comp) + " %  [" + "#".repeat(int(perc_comp/10))+ "-".repeat(10-int(perc_comp/10)) + "]"
				else: 
					game_over()
					return
		$Error.play()
		$LineEdit/AnimationPlayer.play("error")
		$Stats/AnimationPlayer.play("error")
		for word_instantiated in words_instantiated:
			if word_instantiated.word_text == prev_word:
				await word_instantiated.anim_error()
				words_instantiated.erase(word_instantiated)
				word_instantiated.queue_free()
				break
		$LineEdit.text = ""
		streak = 0
		$"Stats/Streak-stat".text=str(streak)
		temp_streak = 0
	prev_word=""
		

func game_over()->void:
	print("GAME OVER")

func win_level()->void:
	if n_level+1 < len(RF_Level_definer.levels):
		n_level+=1
		reset_level()
		init_level()

func reset_level()->void:
	perc_comp = 0
	for word_instantiated in words_instantiated:
		word_instantiated.queue_free()
	words_instantiated = []
	possible_word = []
	perc_comp= 0
	speed_dec=0
	$GameTimer.stop()
	$"Stats/RemTime-stat".text = " 0"
	$SpawnerTimer.stop()
	$CriticEventsTimer.stop()
	prev_word=""
	$LineEdit.text=""

func _on_overclock_pressed() -> void:
	if powerUP[0]>0 and $PU/OverclockPU/OverclockCooldown.is_stopped()==true:
		$PU_audio.play()
		powerUP[0]-=1
		$PU/OverclockPU/Panel/OverclockLabel.text= str(powerUP[0])
		$PU/OverclockPU/OverclockTimer.start()
		speed_dec=15
		for word_instantiated in words_instantiated:
			word_instantiated.fall_speed-=15
		$PU/OverclockPU/Overclock.disabled = true
		$"PU/OverclockPU/OverclockTimer-sec/AnimationPlayer".play("enabled")





func _on_overclock_timer_timeout() -> void:
	speed_dec = 0
	for word_instantiated in words_instantiated:
		word_instantiated.fall_speed+=15
	$PU/OverclockPU/OverclockCooldown.start()
	$"PU/OverclockPU/OverclockTimer-sec/AnimationPlayer".stop()
	$"PU/OverclockPU/OverclockTimer-sec/AnimationPlayer".play("cooldown")
	




func _on_overclock_cooldown_timeout() -> void:
	$PU/OverclockPU/Overclock.disabled = false
	

func _on_shield_pressed() -> void:
	if $PU/ShieldPU/ShieldCooldown.is_stopped()==true:
		if powerUP[1]>0:
			$PU_audio.play()
			powerUP[1]-=1
			$PU/ShieldPU/Panel/ShieldLabel.text= str(powerUP[1])
			shield = true
			$PU/ShieldPU/Shield.disabled = true
			$"PU/ShieldPU/ShieldTimer-sec/AnimationPlayer".play("active")




func _on_shield_cooldown_timeout() -> void:
	$PU/ShieldPU/Shield.disabled = false



func _on_critic_events_timer_timeout() -> void:
	if randi_range(0, 59)>2:
		return
	#* CAPTCHA
	var event = randi_range(0, 2)
	match event:
		1:
			get_tree().paused = true
			$Captcha/AnimationPlayer.play("enter")
			$Event.play()
			await $Captcha/AnimationPlayer.animation_finished
			$Captcha/CaptchaMath.visible = true
			if powerUP[2]>0:
				$Captcha/CaptchaMath/Bypass.visible = true
			var n1
			var n2 
			var op = randi_range(0, 3)
			var ris: float
			var operation: String
			match op:
				0:
					n1 = randi_range(0, 20)
					n2 = randi_range(0, 20)
					ris = n1+n2
					operation = str(n1)+" + "+str(n2)
				1:
					n1 = randi_range(0, 20)
					n2 = randi_range(0, 20)
					ris = n1-n2 if n1>n2 else n2-n1
					operation = str(n1)+" - "+str(n2) if n1>n2 else str(n2)+" - "+str(n1)
				2:
					n1 = randi_range(0, 10)
					n2 = randi_range(0, 10)
					ris = n1*n2
					operation = str(n1)+" * "+str(n2)
				3:
					n1 = randi_range(1, 10)
					n2 = randi_range(1, 10)
					ris = snapped(float(n1)/float(n2), 0.01) if n1>n2 else snapped(float(n2)/float(n1), 0.01)
					operation = str(n1)+" / "+str(n2) if n1>n2 else str(n2)+" / "+str(n1)
			$Captcha/CaptchaMath/Operation.text=operation
			var responses = [-1000, -1000, -1000, -1000]
			var correct_index = randi_range(0, 3)
			responses[correct_index] = ris
			for i in range(len(responses)):
				if responses[i] == -1000:
					responses[i] = ris + randi_range(1, 5) if randi_range(0, 1) == 0 else ris - randi_range(1, 5)
				
			$Captcha/CaptchaMath/Response/R1Container/R1.text = str(responses[0])
			$Captcha/CaptchaMath/Response/R1Container/R1.response_id = 0
			$Captcha/CaptchaMath/Response/R1Container/R1.correct = true if correct_index==0 else false

			$Captcha/CaptchaMath/Response/R2Container/R2.text = str(responses[1])
			$Captcha/CaptchaMath/Response/R2Container/R2.response_id = 1
			$Captcha/CaptchaMath/Response/R2Container/R2.correct = true if correct_index==1 else false

			$Captcha/CaptchaMath/Response/R3Container/R3.text = str(responses[2])
			$Captcha/CaptchaMath/Response/R3Container/R3.response_id = 2
			$Captcha/CaptchaMath/Response/R3Container/R3.correct = true if correct_index==2 else false

			$Captcha/CaptchaMath/Response/R4Container/R4.text = str(responses[3])
			$Captcha/CaptchaMath/Response/R4Container/R4.response_id = 3
			$Captcha/CaptchaMath/Response/R4Container/R4.correct = true if correct_index==3 else false

			$Captcha/CaptchaMath/Response/R1Container/R1.grab_focus()

		2:
			get_tree().paused = true
			$Captcha/CaptchaWord/WordCaptchaInsert.text = ""
			$Captcha/AnimationPlayer.play("enter")
			$Event.play()
			await $Captcha/AnimationPlayer.animation_finished
			$Captcha/CaptchaWord.visible = true
			var word = level.dictionary.keys()[randi_range(0, level.dictionary.size()-1)]
			$Captcha/CaptchaWord/WordWaved.text = word
			if powerUP[2]>0:
				$Captcha/CaptchaWord/Bypass.visible = true
			$Captcha/CaptchaWord/WordCaptchaInsert.grab_focus()
			var response = await $Captcha/CaptchaWord/WordCaptchaInsert.text_submitted
			if response == word:
				$Captcha/CaptchaWord/WordCaptchaInsert/AnimationPlayer.play("success")
				await $Captcha/CaptchaWord/WordCaptchaInsert/AnimationPlayer.animation_finished
				$Captcha/CaptchaWord.visible=false
				$Captcha/AnimationPlayer.play("RESET")
				get_tree().paused = false
				$LineEdit.grab_focus()
			else:
				$Captcha/CaptchaWord/WordCaptchaInsert/AnimationPlayer.play("error")
				await $Captcha/CaptchaWord/WordCaptchaInsert/AnimationPlayer.animation_finished
				$Captcha/CaptchaWord.visible=false
				$Captcha/AnimationPlayer.play("RESET")
				get_tree().paused = false
				if perc_comp-5>=0:
					perc_comp-=5
					$"Stats/PercComp-stat".text = str(perc_comp) + " %  [" + "#".repeat(int(perc_comp/10))+ "-".repeat(10-int(perc_comp/10)) + "]"
					$LineEdit.grab_focus()
				else:
					game_over()
		3:
			print("images")
		
		
func responded(correct) -> void:
	if correct==true:
		get_tree().paused = false
		$"Stats/PercComp-stat".text = str(perc_comp) + " %  [" + "#".repeat(int(perc_comp/10))+ "-".repeat(10-int(perc_comp/10)) + "]"
		$LineEdit.grab_focus()
	else:
		if perc_comp-5>=0:
			perc_comp-=5
		else:
			game_over()


func _on_bypass_pressed() -> void:
	powerUP[2]-=1
	$PU_audio.play()
	$PU/BypassPU/Panel/BypassLabel.text= str(powerUP[2])
	$Captcha/CaptchaMath.visible=false
	$Captcha/CaptchaWord.visible=false
	$Captcha/AnimationPlayer.play("RESET")
	get_tree().paused = false
	
