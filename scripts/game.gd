extends Control


var skip_animation = false


var storyLable
var buttons := []
var containers := []
func _ready() -> void:
	if Global.save_data["settings"]["crt"] == false:
		$CanvasLayer.visible = false
	storyLable = $Panel/Game_elements/StoryLabel
	buttons = [
		$Panel/Game_elements/VBoxContainer/HBoxContainer/Button,
		$Panel/Game_elements/VBoxContainer/HBoxContainer2/Button2,
		$Panel/Game_elements/VBoxContainer/HBoxContainer3/Button3,
		$Panel/Game_elements/VBoxContainer/HBoxContainer4/Button4,
		$Panel/Game_elements/VBoxContainer/HBoxContainer5/Button5,
		$Panel/Game_elements/VBoxContainer/HBoxContainer6/Button6
	]
	
	containers = [
		$Panel/Game_elements/VBoxContainer/HBoxContainer,
		$Panel/Game_elements/VBoxContainer/HBoxContainer2,
		$Panel/Game_elements/VBoxContainer/HBoxContainer3,
		$Panel/Game_elements/VBoxContainer/HBoxContainer4,
		$Panel/Game_elements/VBoxContainer/HBoxContainer5,
		$Panel/Game_elements/VBoxContainer/HBoxContainer6
	]
	insert_username(Global.save_data["username"])
	continue_story()
	

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.write_visited()
		Global.write_data()
		get_tree().quit()

func insert_username(username: String) -> void:
	for storia in Global.storia_classed:
		var new_text = ""
		var start = 0
		var text = storia.text
		
		while true:
			var index = text.find("£", start)
			if index == -1:
				# Non ci sono più simboli £, aggiungiamo il resto
				new_text += text.substr(start, text.length() - start)
				break
			
			# Parte prima del simbolo
			var before = text.substr(start, index - start)
			new_text += before + username
			start = index + 1  # Continua dopo il simbolo
		storia.text = new_text


func write_text(text: String, object: Control):
	var current
	var previous
	var display_text = ""
	var i = 0
	
	while i < text.length():
		if skip_animation == false and Global.save_data["settings"]["skip_animation"] == false:
			if text[i] == "[" and i + 1 < text.length():
				var next_char = text[i + 1]
				# Controlliamo se è un tag BBCode valido: inizia con lettera (a-z / A-Z) o '/'
				if is_ascii_letter(next_char) or next_char == "/":
					var end_idx = text.find("]", i)
					if end_idx != -1:
						# È un tag: aggiungiamo subito senza attendere
						display_text += text.substr(i, end_idx - i + 1)
						i = end_idx + 1
						continue
			# Non è un tag, scriviamo normalmente
			current = text[i]
			previous = text[i - 1] if i > 0 else ""
			
			display_text += current
			object.text = display_text
			
			if current == " " and previous == " ":
				pass
			elif (current == "-" and previous == "-") || (current == "═" and previous == "═") || current == "─" and previous == "─":
				$Panel/Timer.wait_time = 0.03
				$Panel/Timer.start()
				await $Panel/Timer.timeout
			else:
				$Panel/Timer.wait_time = 0.05
				$Panel/Timer.start()
				await $Panel/Timer.timeout
			i += 1
		else:
			object.text = text
			break

func is_ascii_letter(letter) -> bool:
	if letter.to_lower() >= "a" and letter.to_lower() <= "z":
		return true
	else: 
		return false

func clear_buttons() -> void:
	for i in range(len(containers)):
		containers[i].visible = false
	for i in range(len(buttons)):
		buttons[i].text = ""
		buttons[i].scene_id = ""
		buttons[i].disabled = true
	skip_animation = false

func enable_button(i: int, scene_id: String) -> void:
	buttons[i].disabled = false
	buttons[i].set_scene_id(scene_id)
	containers[i].visible = true
	await write_text(Global.get_scene_class(scene_id).get_scene_name(), buttons[i])
	

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			if buttons[0].has_focus():
				_on_button_pressed()
				accept_event()
			elif buttons[1].has_focus():
				_on_button_2_pressed()
				accept_event()
			elif buttons[2].has_focus():
				_on_button_3_pressed()
				accept_event()
			elif buttons[3].has_focus():
				_on_button_4_pressed()
				accept_event()
			elif buttons[4].has_focus():
				_on_button_5_pressed()
				accept_event()
			else:
				pass
		elif event.keycode == KEY_SPACE:
			skip_animation = true
			accept_event()


func _on_button_pressed() -> void:
	Global.get_scene_class(buttons[0].scene_id).set_visited()
	Global.save_data["scene"] = buttons[0].scene_id
	clear_buttons()
	continue_story()
	


func _on_button_2_pressed() -> void:
	Global.get_scene_class(buttons[1].scene_id).set_visited()
	Global.save_data["scene"] = buttons[1].scene_id
	clear_buttons()
	continue_story()


func _on_button_3_pressed() -> void:
	Global.get_scene_class(buttons[2].scene_id).set_visited()
	Global.save_data["scene"] = buttons[2].scene_id
	clear_buttons()
	continue_story()


func _on_button_4_pressed() -> void:
	Global.get_scene_class(buttons[3].scene_id).set_visited()
	Global.save_data["scene"] = buttons[3].scene_id
	clear_buttons()
	continue_story()

func _on_button_5_pressed() -> void:
	Global.get_scene_class(buttons[4].scene_id).set_visited()
	Global.save_data["scene"] = buttons[4].scene_id
	clear_buttons()
	continue_story()

func _on_button_6_pressed() -> void:
	Global.get_scene_class(buttons[5].scene_id).set_visited()
	Global.save_data["scene"] = buttons[5].scene_id
	clear_buttons()
	continue_story()
	
func continue_story():
	match Global.save_data["scene"]:
		"0": # intro
			await write_text(Global.get_scene_class("0").get_scene_text(), storyLable) 
			
			await enable_button(0, "0.1") # rovista tra la posta
			await enable_button(1, "0.2") # affacciati alla finestra
			await enable_button(2, "0.3") # guarda il calendario
			await enable_button(3, "1") # siediti alla scrivania
			buttons[0].grab_focus()
		"0.1": # rovista tra la posta 
			await write_text(Global.get_scene_class("0.1").get_scene_text(), storyLable) 
			var i = 0
			if Global.get_scene_class("0.2").get_visited() == false: # affacciati alla finestra
				await enable_button(i, "0.2")
				i+=1
			if Global.get_scene_class("0.3").get_visited() == false: # guarda il calendario
				await enable_button(i, "0.3")
				i+=1
			await enable_button(i, "1") # siediti alla scrivania
			buttons[0].grab_focus()
		"0.2": # affacciati alla finestra 
			await write_text(Global.get_scene_class("0.2").get_scene_text(), storyLable) 
			var i = 0
			if Global.get_scene_class("0.1").get_visited() == false: # rovista tra la posta
				await enable_button(i, "0.1")
				i+=1
			if Global.get_scene_class("0.3").get_visited() == false: #guarda il calendario
				await enable_button(i, "0.3")
				i+=1
			await enable_button(i, "1") # siediti alla scrivania
			buttons[0].grab_focus()
		"0.3": # guarda il calendario
			await write_text(Global.get_scene_class("0.3").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("0.1").get_visited() == false: # rovista tra la posta
				await enable_button(i, "0.1")
				i+=1
			if Global.get_scene_class("0.2").get_visited() == false: # affacciati alla finestra
				await enable_button(i, "0.2")
				i+=1
			await enable_button(i, "1") # siediti alla scrivania
			buttons[0].grab_focus()
		"1": # siediti alla scrivania
			await write_text(Global.get_scene_class("1").get_scene_text(), storyLable) 
			
			await enable_button(0, "1.1") # apri il pacco
			await enable_button(1, "1.2") # apri il bbs
			await enable_button(2, "1.3") # guarda le mail
			
			buttons[0].grab_focus()
		"1.1": # apri il pacco
			await write_text(Global.get_scene_class("1.1").get_scene_text(), storyLable)
			await enable_button(0, "1.1.1") # chiama il numero
			await enable_button(1, "1.1.2") # ignora il postit
			buttons[0].grab_focus()
		"1.1.1": # hai chiamato
			await write_text(Global.get_scene_class("1.1.1").get_scene_text(), storyLable)
			var i = 0
			if Global.get_scene_class("1.2").get_visited() == false: # apri il BBS
				await enable_button(i, "1.2")
				i+=1
			
			await enable_button(i, "1.3") # guarda la mail
			buttons[0].grab_focus()
		"1.1.2": # hai ignorato il numero
			await write_text(Global.get_scene_class("1.1.2").get_scene_text(), storyLable) 
			var i = 0
			if Global.get_scene_class("1.2").get_visited() == false:
				await enable_button(i, "1.2") # apri bbs
				i+=1
			
			await enable_button(i, "1.3") # guarda mail
			buttons[0].grab_focus()
		"1.2": # apri il BBS
			await write_text(Global.get_scene_class("1.2").get_scene_text(), storyLable) 
			
			await enable_button(0, "1.2.1") # general chat
			
			await enable_button(1, "1.2.2") # programming
			
			await enable_button(2, "1.2.3") # games
			
			await enable_button(3, "1.2.4") # download
			
			await enable_button(4, "1.2.5") # system message
			
			buttons[0].grab_focus()
		"1.2.1": # general chat
			await write_text(Global.get_scene_class("1.2.1").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("1.2.2").get_visited() == false: # programming
				await enable_button(i, "1.2.2")
				i+=1
			if Global.get_scene_class("1.2.3").get_visited() == false: # games
				await enable_button(i, "1.2.3")
				i+=1
			if Global.get_scene_class("1.2.4").get_visited() == false: # download
				await enable_button(i, "1.2.4")
				i+=1
			if Global.get_scene_class("1.2.5").get_visited() == false: # system message
				await enable_button(i, "1.2.5")
				i+=1
			await enable_button(i, "1.2.6")
			buttons[0].grab_focus()
		"1.2.2": # programming
			await write_text(Global.get_scene_class("1.2.2").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("1.2.1").get_visited() == false: # general chat
				await enable_button(i, "1.2.1")
				i+=1
			if Global.get_scene_class("1.2.3").get_visited() == false: # games
				await enable_button(i, "1.2.3")
				i+=1
			if Global.get_scene_class("1.2.4").get_visited() == false: # download
				await enable_button(i, "1.2.4")
				i+=1
			if Global.get_scene_class("1.2.5").get_visited() == false: # system message
				await enable_button(i, "1.2.5")
				i+=1
			await enable_button(i, "1.2.6")
			buttons[0].grab_focus()
		"1.2.3": # games
			await write_text(Global.get_scene_class("1.2.3").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("1.2.1").get_visited() == false: # general chat
				await enable_button(i, "1.2.1")
				i+=1
			if Global.get_scene_class("1.2.2").get_visited() == false: # programming
				await enable_button(i, "1.2.2")
				i+=1
			if Global.get_scene_class("1.2.4").get_visited() == false: # download
				await enable_button(i, "1.2.4")
				i+=1
			if Global.get_scene_class("1.2.5").get_visited() == false: # system message
				await enable_button(i, "1.2.5")
				i+=1
			await enable_button(i, "1.2.6")
			buttons[0].grab_focus()
		"1.2.4": # download
			await write_text(Global.get_scene_class("1.2.4").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("1.2.1").get_visited() == false: # general chat
				await enable_button(i, "1.2.1")
				i+=1
			if Global.get_scene_class("1.2.2").get_visited() == false: # programming
				await enable_button(i, "1.2.2")
				i+=1
			if Global.get_scene_class("1.2.3").get_visited() == false: # games
				await enable_button(i, "1.2.3")
				i+=1
			if Global.get_scene_class("1.2.5").get_visited() == false: # system message
				await enable_button(i, "1.2.5")
				i+=1
			await enable_button(i, "1.2.6")
			buttons[0].grab_focus()
		"1.2.5": # system messages
			await write_text(Global.get_scene_class("1.2.5").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("1.2.1").get_visited() == false: # general chat
				await enable_button(i, "1.2.1")
				i+=1
			if Global.get_scene_class("1.2.2").get_visited() == false: # programming
				await enable_button(i, "1.2.2")
				i+=1
			if Global.get_scene_class("1.2.3").get_visited() == false: # games
				await enable_button(i, "1.2.3")
				i+=1
			if Global.get_scene_class("1.2.4").get_visited() == false: # download
				await enable_button(i, "1.2.4")
				i+=1
			await enable_button(i, "1.2.6")
			buttons[0].grab_focus()
		"1.2.6": # echo chamber
			await write_text(Global.get_scene_class("1.2.6").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("1.2.1").get_visited() == false: # general chat
				await enable_button(i, "1.2.1")
				i+=1
			if Global.get_scene_class("1.2.2").get_visited() == false: # programming
				await enable_button(i, "1.2.2")
				i+=1
			if Global.get_scene_class("1.2.3").get_visited() == false: # games
				await enable_button(i, "1.2.3")
				i+=1
			if Global.get_scene_class("1.2.4").get_visited() == false: # download
				await enable_button(i, "1.2.4")
				i+=1
			if Global.get_scene_class("1.2.5").get_visited() == false: # system messages
				await enable_button(i, "1.2.5")
				i+=1
			await enable_button(i, "1.3")
			buttons[0].grab_focus()
		"1.3": # controlla email
			await write_text(Global.get_scene_class("1.3").get_scene_text(), storyLable)  
			
			await enable_button(0, "1.3.1")
			await enable_button(1, "2")
			buttons[0].grab_focus()
		"1.3.1": # ignora la mail
			
			var BSOD_scene = load("res://scenes/BSOD.tscn")
			var bsod = BSOD_scene.instantiate()
			add_child(bsod)
			storyLable.text = ""
			var anim_player = bsod.get_node("AnimationPlayer")
			anim_player.animation_finished.connect(func(_anim_name):
				Global.save_data["scene"] = "1.3"
				continue_story()
				bsod.queue_free()
			)
			anim_player.play("BSOD")
		"2": # accedi all'ip di echo chamber
			await write_text(Global.get_scene_class("2").get_scene_text(), storyLable)
			await enable_button(0, "2.1") # post dk
			await enable_button(1, "2.2") # post cipher
			await enable_button(2, "2.3") # post neuromancer
			await enable_button(3, "2.4") # post tesla_x
			await enable_button(4, "2.5") # post valis
			await enable_button(5, "2.6") # post phantom
			buttons[0].grab_focus()
		"2.1": # post di dk
			await write_text(Global.get_scene_class("2.1").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("2.2").get_visited() == false: # post cipher
				await enable_button(i, "2.2")
				i+=1
			if Global.get_scene_class("2.3").get_visited() == false: # post neuromancer
				await enable_button(i, "2.3")
				i+=1
			if Global.get_scene_class("2.4").get_visited() == false: # post tesla_x
				await enable_button(i, "2.4")
				i+=1
			if Global.get_scene_class("2.5").get_visited() == false: # post valis
				await enable_button(i, "2.5")
				i+=1
			if Global.get_scene_class("2.6").get_visited() == false: # post phantom
				await enable_button(i, "2.6")
				i+=1
			await enable_button(i, "3") # messaggio dk
			buttons[0].grab_focus()
		"2.2": # post di cipher
			await write_text(Global.get_scene_class("2.2").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("2.1").get_visited() == false: # post dk
				await enable_button(i, "2.1")
				i+=1
			if Global.get_scene_class("2.3").get_visited() == false: # post neuromancer
				await enable_button(i, "2.3")
				i+=1
			if Global.get_scene_class("2.4").get_visited() == false: # post tesla_x
				await enable_button(i, "2.4")
				i+=1
			if Global.get_scene_class("2.5").get_visited() == false: # post valis
				await enable_button(i, "2.5")
				i+=1
			if Global.get_scene_class("2.6").get_visited() == false: # post phantom
				await enable_button(i, "2.6")
				i+=1
			await enable_button(i, "3") # messaggio dk
			buttons[0].grab_focus()
		"2.3": # post di neuromancer
			await write_text(Global.get_scene_class("2.3").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("2.1").get_visited() == false: # post dk
				await enable_button(i, "2.1")
				i+=1
			if Global.get_scene_class("2.2").get_visited() == false: # post cipher
				await enable_button(i, "2.2")
				i+=1
			if Global.get_scene_class("2.4").get_visited() == false: # post tesla_x
				await enable_button(i, "2.4")
				i+=1
			if Global.get_scene_class("2.5").get_visited() == false: # post valis
				await enable_button(i, "2.5")
				i+=1
			if Global.get_scene_class("2.6").get_visited() == false: # post phantom
				await enable_button(i, "2.6")
				i+=1
			await enable_button(i, "3") # messaggio dk
			buttons[0].grab_focus()
		"2.4": # post di tesla_x
			await write_text(Global.get_scene_class("2.4").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("2.1").get_visited() == false: # post dk
				await enable_button(i, "2.1")
				i+=1
			if Global.get_scene_class("2.2").get_visited() == false: # post cipher
				await enable_button(i, "2.2")
				i+=1
			if Global.get_scene_class("2.3").get_visited() == false: # post neuromancer
				await enable_button(i, "2.3")
				i+=1
			if Global.get_scene_class("2.5").get_visited() == false: # post valis
				await enable_button(i, "2.5")
				i+=1
			if Global.get_scene_class("2.6").get_visited() == false: # post phantom
				await enable_button(i, "2.6")
				i+=1
			await enable_button(i, "3") # messaggio dk
			buttons[0].grab_focus()
		"2.5": # post di valis
			await write_text(Global.get_scene_class("2.5").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("2.1").get_visited() == false: # post dk
				await enable_button(i, "2.1")
				i+=1
			if Global.get_scene_class("2.2").get_visited() == false: # post cipher
				await enable_button(i, "2.2")
				i+=1
			if Global.get_scene_class("2.3").get_visited() == false: # post neuromancer
				await enable_button(i, "2.3")
				i+=1
			if Global.get_scene_class("2.4").get_visited() == false: # post tesla_x
				await enable_button(i, "2.4")
				i+=1
			if Global.get_scene_class("2.6").get_visited() == false: # post phantom
				await enable_button(i, "2.6")
				i+=1
			await enable_button(i, "3") # messaggio dk
			buttons[0].grab_focus()
		"2.6": # post di phantom
			await write_text(Global.get_scene_class("2.6").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("2.1").get_visited() == false: # post dk
				await enable_button(i, "2.1")
				i+=1
			if Global.get_scene_class("2.2").get_visited() == false: # post cipher
				await enable_button(i, "2.2")
				i+=1
			if Global.get_scene_class("2.3").get_visited() == false: # post neuromancer
				await enable_button(i, "2.3")
				i+=1
			if Global.get_scene_class("2.4").get_visited() == false: # post tesla_x
				await enable_button(i, "2.4")
				i+=1
			if Global.get_scene_class("2.5").get_visited() == false: # post valis
				await enable_button(i, "2.5")
				i+=1
			await enable_button(i, "3") # messaggio dk
			buttons[0].grab_focus()
		"3": # messaggio dk
			await write_text(Global.get_scene_class("3").get_scene_text(), storyLable)  
			await  enable_button(0, "3.1") # continua ad esplorare l'echo chamber
			await enable_button(1, "3.2")# accedi alla chat
			buttons[0].grab_focus()
		"3.1": #continua ad esplorare l'echo chamber
			await write_text(Global.get_scene_class("3.1").get_scene_text(), storyLable)  
			await enable_button(0, "3.1.1") # KD
			await enable_button(1, "3.1.2") # Phantom
			await enable_button(2, "3.1.3") # Chiper
			await enable_button(3, "3.1.4") # Tesla_x
			await enable_button(4, "3.1.5") # Valis
			buttons[0].grab_focus()
		"3.1.1": # DK
			await write_text(Global.get_scene_class("3.1.1").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("3.1.2").get_visited() == false: # Cipher
				await enable_button(i, "3.1.2")
				i+=1
			if Global.get_scene_class("3.1.3").get_visited() == false: # neuromancer
				await enable_button(i, "3.1.3")
				i+=1
			if Global.get_scene_class("3.1.4").get_visited() == false: # tesla_x
				await enable_button(i, "3.1.4")
				i+=1
			if Global.get_scene_class("3.1.5").get_visited() == false: # valis
				await enable_button(i, "3.1.5")
				i+=1
			if Global.get_scene_class("3.1.6").get_visited() == false: # valis
				await enable_button(i, "3.1.6")
				i+=1
			await enable_button(i, "3.2") # accedi alla chat 
			buttons[0].grab_focus()
		"3.1.2": # Phantom
			await write_text(Global.get_scene_class("3.1.2").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("3.1.1").get_visited() == false: # Cipher
				await enable_button(i, "3.1.1")
				i+=1
			if Global.get_scene_class("3.1.3").get_visited() == false: # neuromancer
				await enable_button(i, "3.1.3")
				i+=1
			if Global.get_scene_class("3.1.4").get_visited() == false: # tesla_x
				await enable_button(i, "3.1.4")
				i+=1
			if Global.get_scene_class("3.1.5").get_visited() == false: # valis
				await enable_button(i, "3.1.5")
				i+=1
			if Global.get_scene_class("3.1.6").get_visited() == false: # valis
				await enable_button(i, "3.1.6")
				i+=1
			await enable_button(i, "3.2") # accedi alla chat 
			buttons[0].grab_focus()
		"3.1.3": # Chiper
			await write_text(Global.get_scene_class("3.1.3").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("3.1.1").get_visited() == false: # Cipher
				await enable_button(i, "3.1.1")
				i+=1
			if Global.get_scene_class("3.1.2").get_visited() == false: # neuromancer
				await enable_button(i, "3.1.2")
				i+=1
			if Global.get_scene_class("3.1.4").get_visited() == false: # tesla_x
				await enable_button(i, "3.1.4")
				i+=1
			if Global.get_scene_class("3.1.5").get_visited() == false: # valis
				await enable_button(i, "3.1.5")
				i+=1
			if Global.get_scene_class("3.1.6").get_visited() == false: # valis
				await enable_button(i, "3.1.6")
				i+=1
			await enable_button(i, "3.2") # accedi alla chat 
			buttons[0].grab_focus()
		"3.1.4": # Neuromancer
			await write_text(Global.get_scene_class("3.1.4").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("3.1.1").get_visited() == false: # Cipher
				await enable_button(i, "3.1.1")
				i+=1
			if Global.get_scene_class("3.1.2").get_visited() == false: # neuromancer
				await enable_button(i, "3.1.2")
				i+=1
			if Global.get_scene_class("3.1.3").get_visited() == false: # tesla_x
				await enable_button(i, "3.1.3")
				i+=1
			if Global.get_scene_class("3.1.5").get_visited() == false: # valis
				await enable_button(i, "3.1.5")
				i+=1
			if Global.get_scene_class("3.1.6").get_visited() == false: # valis
				await enable_button(i, "3.1.6")
				i+=1
			await enable_button(i, "3.2") # accedi alla chat 
			buttons[0].grab_focus()
		"3.1.5": # Tesla_x
			await write_text(Global.get_scene_class("3.1.5").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("3.1.1").get_visited() == false: # Cipher
				await enable_button(i, "3.1.1")
				i+=1
			if Global.get_scene_class("3.1.2").get_visited() == false: # neuromancer
				await enable_button(i, "3.1.2")
				i+=1
			if Global.get_scene_class("3.1.3").get_visited() == false: # tesla_x
				await enable_button(i, "3.1.3")
				i+=1
			if Global.get_scene_class("3.1.4").get_visited() == false: # valis
				await enable_button(i, "3.1.4")
				i+=1
			if Global.get_scene_class("3.1.6").get_visited() == false: # phantom
				await enable_button(i, "3.1.6")
				i+=1
			await enable_button(i, "3.2") # accedi alla chat 
			buttons[0].grab_focus()
		"3.1.6": # Valis
			await write_text(Global.get_scene_class("3.1.6").get_scene_text(), storyLable)  
			var i = 0
			if Global.get_scene_class("3.1.1").get_visited() == false: # Cipher
				await enable_button(i, "3.1.1")
				i+=1
			if Global.get_scene_class("3.1.2").get_visited() == false: # neuromancer
				await enable_button(i, "3.1.2")
				i+=1
			if Global.get_scene_class("3.1.3").get_visited() == false: # tesla_x
				await enable_button(i, "3.1.3")
				i+=1
			if Global.get_scene_class("3.1.4").get_visited() == false: # valis
				await enable_button(i, "3.1.4")
				i+=1
			if Global.get_scene_class("3.1.5").get_visited() == false: # phantom
				await enable_button(i, "3.1.5")
				i+=1
			await enable_button(i, "3.2") # accedi alla chat 
			buttons[0].grab_focus()
		"3.2": # accedi alla chat
			await write_text(Global.get_scene_class("3.2").get_scene_text(), storyLable)  
			await  enable_button(0, "3.2.1") # quanto è legale
			await enable_button(1, "3.2.2") # che tipo di compenso
			await enable_button(2, "3.2.3") # sono interessato
			buttons[0].grab_focus()
		"3.2.1": # quanto è legale
			await write_text(Global.get_scene_class("3.2.1").get_scene_text(), storyLable)
			var i = 0
			if Global.get_scene_class("3.2.2").get_visited() == false: # 
				await enable_button(i, "3.2.2") # che tipo di compenso
				i+=1
			await enable_button(i, "3.2.3") # sono interessato
			buttons[0].grab_focus()
		"3.2.2": # che tipo di compenso
			await write_text(Global.get_scene_class("3.2.2").get_scene_text(), storyLable)
			var i = 0
			if Global.get_scene_class("3.2.1").get_visited() == false: 
				await enable_button(i, "3.2.1") # quanto è legale
				i+=1
			await enable_button(i, "3.2.3") #sono interessato
			buttons[0].grab_focus()
		"3.2.3": # sono interessato
			await write_text(Global.get_scene_class("3.2.3").get_scene_text(), storyLable)
			await enable_button(0, "3.2.3.1") # voglio sapere chi siete
			await enable_button(1, "3.2.3.2") # ho bisogno di pensarci
			await enable_button(2, "3.2.3.3") # sono dentro
		"3.2.3.1": # voglio sapere chi siete
			await write_text(Global.get_scene_class("3.2.3.1").get_scene_text(), storyLable)
			var i = 0 
			if Global.get_scene_class("3.2.3.2").get_visited() == false: 
				await enable_button(i, "3.2.3.2") # ho bisgno di pensarci
				i+=1
			await enable_button(i, "3.2.3.3") # sono dentro
			buttons[0].grab_focus()
		"3.2.3.2": # ho bisogno di pensarci
			await write_text(Global.get_scene_class("3.2.3.2").get_scene_text(), storyLable)
			var i = 0
			if Global.get_scene_class("3.2.3.1").get_visited() == false:
				await enable_button(i, "3.2.3.1") # voglio sapere chi siete
				i+=1
			await enable_button(i, "3.2.3.3") # sono dentro
			buttons[0].grab_focus()
		"3.2.3.3": # sono dentro
			await write_text(Global.get_scene_class("3.2.3.3").get_scene_text(), storyLable)
			await enable_button(0, "4") # sviluppa marcketplace
			buttons[0].grab_focus()
		"4": # sviluppa marcketplace
			await write_text(Global.get_scene_class("4").get_scene_text(), storyLable)
			await enable_button(0, "4.1") # esamina i messaggi di chiper
			await enable_button(1, "4.2") # collabora con neuromancer
			await enable_button(2, "5") # partecipa alla riunione di DK
			buttons[0].grab_focus()
		"4.1": # esamina i messaggi di chiper
			await write_text(Global.get_scene_class("4.1").get_scene_text(), storyLable)
			await enable_button(0, "4.1.1") # proponi routing adattivo
			await enable_button(1, "4.1.2") # proponi nodi distribuiti
			buttons[0].grab_focus()
		"4.1.1": # routing adattivo
			await write_text(Global.get_scene_class("4.1.1").get_scene_text(), storyLable)
			var i = 0
			if Global.get_scene_class("4.2").get_visited() == false:
				await enable_button(i, "4.2") # collabora con neuromancer
				i+=1
			await enable_button(i, "5") # partecipa alla riunione di DK
			buttons[0].grab_focus()
		"4.1.2": # nodi distribuiti
			await write_text(Global.get_scene_class("4.1.2").get_scene_text(), storyLable)
			var i = 0
			if Global.get_scene_class("4.2").get_visited() == false:
				await enable_button(i, "4.2") # collabora con neuromancer
				i+=1
			await enable_button(i, "5") # partecipa alla riunione di DK
			buttons[0].grab_focus()
		"4.2": # collabora con neuromancer
			await write_text(Global.get_scene_class("4.2").get_scene_text(), storyLable)
			await enable_button(0, "4.2.1") # timestamp distribuito
			await enable_button(1, "4.2.2") # reputazione blind trust
			buttons[0].grab_focus()
		"4.2.1": # timestamp distribuito
			await write_text(Global.get_scene_class("4.2.1").get_scene_text(), storyLable)
			var i = 0
			if Global.get_scene_class("4.1").get_visited() == false:
				await enable_button(i, "4.1") # esamina i messaggi di chiper
				i+=1
			await enable_button(i, "5") # partecipa alla riunione di DK
			buttons[0].grab_focus()
		"4.2.2": # reputazione blind trust
			await write_text(Global.get_scene_class("4.2.2").get_scene_text(), storyLable)
			var i = 0
			if Global.get_scene_class("4.1").get_visited() == false:
				await enable_button(i, "4.1") # esamina i messaggi di chiper
				i+=1
			await enable_button(i, "5") # partecipa alla riunione di DK
			buttons[0].grab_focus()
		"5": # partecipa alla riunione di DK
			await write_text(Global.get_scene_class("5").get_scene_text(), storyLable)
			await enable_button(0, "5.1") # modello decentralizzato
			await enable_button(1, "5.2") # consiglio di amministrazione
			buttons[0].grab_focus()
		"5.1": # modello decentralizzato
			await write_text(Global.get_scene_class("5.1").get_scene_text(), storyLable)
			await enable_button(0, "6")
			buttons[0].grab_focus()
		"5.2": # consiglio di amministrazione
			await write_text(Global.get_scene_class("5.2").get_scene_text(), storyLable)
			await enable_button(0, "6")
			buttons[0].grab_focus()
		"6": # attività sospette
			await write_text(Global.get_scene_class("6").get_scene_text(), storyLable)
			await enable_button(0, "6.1") # indaga personalmente
			await enable_button(1, "6.2") # riferisci a DK
			buttons[0].grab_focus()
		"6.1": # indaga personalmente
			await write_text(Global.get_scene_class("6.1").get_scene_text(), storyLable)
			await enable_button(0, "7") # procedi con il lancio
			buttons[0].grab_focus()
		"6.2": # routing adattivo
			await write_text(Global.get_scene_class("6.2").get_scene_text(), storyLable)
			await enable_button(0, "7") #procedi con il lancio
			buttons[0].grab_focus()
		"7": # procedi con il lancio
			await write_text(Global.get_scene_class("7").get_scene_text(), storyLable)
			await enable_button(0, "7.1") # esprimi preoccupazione
			await enable_button(1, "7.2") # esprimi ottimismo
			buttons[0].grab_focus()
		"7.1": # esprimi preoccupazione
			await write_text(Global.get_scene_class("7.1").get_scene_text(), storyLable)
			await enable_button(0, "8") # partecipa alla cerimonia di lancio
			buttons[0].grab_focus()
		"7.2": # esprimi ottimismo
			await write_text(Global.get_scene_class("7.2").get_scene_text(), storyLable)
			await enable_button(0, "8") # partecipa alla cerimonia di lancio
			buttons[0].grab_focus()
		"8": # partecipa alla cerimonia di lancio
			await write_text(Global.get_scene_class("8").get_scene_text(), storyLable)
			await enable_button(0, "8.1") # inserisci la chiave
			await enable_button(1, "8.2") # esita
			buttons[0].grab_focus()
		"8.1": # inserisci la chiave
			await write_text(Global.get_scene_class("8.1").get_scene_text(), storyLable)
			await enable_button(0, "9") # contina a monitorare
			buttons[0].grab_focus()
		"8.2": # esita
			await write_text(Global.get_scene_class("8.2").get_scene_text(), storyLable)
			await enable_button(0, "9") # contina a monitorare
			buttons[0].grab_focus()
		"9": # contina a monitorare
			await write_text(Global.get_scene_class("9").get_scene_text(), storyLable)
			await enable_button(0, "10") # gioca a defend the bazaar
			await enable_button(1, "11") # continua la storia
			buttons[0].grab_focus()
		"10": #! gioca a defend the bazaar
			pass
		"11": # continua la storia
			await write_text(Global.get_scene_class("11").get_scene_text(), storyLable)
			await enable_button(0, "11.1") # contatta DC
			await enable_button(1, "11.2") # indaga autonomamentoe
			await enable_button(2, "11.3") # contatta DK
			buttons[0].grab_focus()
		"11.1": # contatta DC
			await write_text(Global.get_scene_class("11.1").get_scene_text(), storyLable)
			await enable_button(0, "12") # continua ad indagare
			buttons[0].grab_focus()
		"11.2": # indaga autonomamente
			await write_text(Global.get_scene_class("11.2").get_scene_text(), storyLable)
			await enable_button(0, "12") # continua ad indagare
			buttons[0].grab_focus()
		"11.3": # contatta DK
			await write_text(Global.get_scene_class("11.3").get_scene_text(), storyLable)
			await enable_button(0, "12") # continua ad indagare
			buttons[0].grab_focus()
		"12": # continua ad indagare
			await write_text(Global.get_scene_class("12").get_scene_text(), storyLable)
			await enable_button(0, "12.1") # continua ...
			buttons[0].grab_focus()
		"12.1": # continua ...
			await write_text(Global.get_scene_class("12.1").get_scene_text(), storyLable)
			await enable_button(0, "13.1") # mantieni i principi 
			await enable_button(1, "13.2") # cedi alla concorrenza
			buttons[0].grab_focus()
		"13.1": # mantieni i principi
			await write_text(Global.get_scene_class("13.1").get_scene_text(), storyLable)
			await enable_button(0, "14") # termina la riunione
			buttons[0].grab_focus()
		"13.2": # cedi alla concorrenza
			await write_text(Global.get_scene_class("13.2").get_scene_text(), storyLable)
			await enable_button(0, "14") # termina la riunione
			buttons[0].grab_focus()
		"14": # termina la riunione
			await write_text(Global.get_scene_class("14").get_scene_text(), storyLable)
			await enable_button(0, "15") # gioca ai minigiochi
			await enable_button(1, "16") # continua la storia
		"15": #! minigiochi
			pass
		"16": # continua la storia
			await write_text(Global.get_scene_class("16").get_scene_text(), storyLable)
			if Global.get_scene_class("13.1").get_visited() == true:
				await enable_button(1, "17") # mantieni i principi
			elif Global.get_scene_class("13.2").get_visited() == true:
				await enable_button(1, "18") # non li mantieni
			buttons[0].grab_focus()
		# FINALI ETICI
		"17": # mantieni i principi
			await write_text(Global.get_scene_class("17").get_scene_text(), storyLable)
			await enable_button(0, "17.1") # accetta l'offerta di DC
			await enable_button(1, "17.2") # prenditi tempo per pensare
			buttons[0].grab_focus()
		# FINALE 1
		"17.1": # accetta l'offerta di DC
			await write_text(Global.get_scene_class("17.1").get_scene_text(), storyLable)
			# TODO
		"17.2": # prenditi tempo per pensare
			await write_text(Global.get_scene_class("17.2").get_scene_text(), storyLable)
			await enable_button(0, "17.2.1") # accetta la proposta di pahntom
			await enable_button(1, "17.2.2") # accetta la proposta di DC
			buttons[0].grab_focus()
		# FINALE 2
		"17.2.1": # accetta la proposta di phantom
			await write_text(Global.get_scene_class("17.2.1").get_scene_text(), storyLable)
			await enable_button(0, "17.2.1.1") # minigioco
			await enable_button(1, "17.2.1.2") # continua la storia
			buttons[0].grab_focus()
		"17.2.1.1": #! gioca al minigioco
			pass
		"17.2.1.2": # finale
			await write_text(Global.get_scene_class("17.2.1.2").get_scene_text(), storyLable)

		# RITORNO AL FINALE 1
		"17.2.2": # accetta la proposta di DC
			await write_text(Global.get_scene_class("17.2.2.1").get_scene_text(), storyLable)
			buttons[0].disabled = false
			buttons[0].set_scene_id("17.1")
			containers[0].visible = true
			await write_text("Continua ...", buttons[0])

		# FINALI NON ETICI

		# FINALE 1
		"18": 
			pass
