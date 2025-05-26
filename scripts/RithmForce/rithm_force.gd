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



func _process(_delta: float) -> void:
	if $GameTimer!=null and $GameTimer.is_stopped() == false:
		$"Stats/RemTime-stat".text = str(int($GameTimer.time_left))


func _ready() -> void:
	await get_tree().create_timer(5).timeout
	init_level()
	$LineEdit.grab_focus()


func init_level() -> void:
	$StatusBar/Level.text = "LEVEL: " + str(n_level+1)
	$"Stats/PercComp-stat".text = str(perc_comp) + "%  [----------]"
	level = RF_Level_definer.levels[n_level]
	$GameTimer.wait_time = level.level_max_time
	$SpawnerTimer.wait_time = level.spawn_rate
	possible_word = level.dictionary.keys()
	$GameTimer.start()
	$SpawnerTimer.start()


func _on_game_timer_timeout() -> void:
	pass

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

	word_instantiated.fall_speed = level.fall_speed
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
		match body.difficulty:
			1:
				perc_comp-=5
				$"Stats/PercComp-stat".text = str(perc_comp) + " %  [" + "#".repeat(int(perc_comp/10))+ "-".repeat(10-int(perc_comp/10)) + "]"
		words_instantiated.erase(body)
	body.queue_free()


var prev_word:= ""

func _on_line_edit_text_changed(new_text: String) -> void:
	for word_instantiated in words_instantiated:
		var text = word_instantiated.word_text
		if text.begins_with(new_text):
			word_instantiated.set_text("[color=green]" + new_text + "[/color]" + text.substr(new_text.length()))
			prev_word = text
		else:
			word_instantiated.set_text(text)

func _on_line_edit_text_submitted(new_text: String) -> void:
	var finded:= false
	for word_instantiated in words_instantiated:
		var text = word_instantiated.word_text
		if text == new_text:
			match  word_instantiated.difficulty:
				1: 
					perc_comp+=5
					$"Stats/PercComp-stat".text = str(perc_comp) + " %  [" + "#".repeat(int(perc_comp/10))+ "-".repeat(10-int(perc_comp/10)) + "]"
			words_instantiated.erase(word_instantiated)
			word_instantiated.queue_free()
			$LineEdit.text = ""
			return
	if finded==false:
		match level.dictionary[prev_word]:
			1:
				perc_comp-=5
				$"Stats/PercComp-stat".text = str(perc_comp) + " %  [" + "#".repeat(int(perc_comp/10))+ "-".repeat(10-int(perc_comp/10)) + "]"
		$LineEdit/AnimationPlayer.play("error")
		for word_instantiated in words_instantiated:
			if word_instantiated.word_text == prev_word:
				await word_instantiated.anim_error()
				words_instantiated.erase(word_instantiated)
				word_instantiated.queue_free()
				break
		$LineEdit.text = ""
