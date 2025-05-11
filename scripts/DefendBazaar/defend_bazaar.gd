extends Node

signal level_up_requested

var defence_button = preload("res://scenes/DefendBazaar/defence_button.tscn")
var attack = preload("res://scenes/DefendBazaar/Attack.tscn")

var conf := 0
var integ := 0
var disp := 0

var btc := 0

var defence_buttons := []
var defence_built := []
var attack_spawned := []
var n_level_playing = 1

func _ready():
	if Global.save_data["settings"]["crt"] == false:
		$CanvasLayer.visible = false
	
	init_level(n_level_playing)
	connect("level_up_requested", Callable(self, "_on_level_up_requested"))


func init_level(n_level:int) -> void:
	var playzone = get_node("PlayZone")
	var level = LevelDefiner.get_level(n_level)
	$TerminalBar/StatusBar/Level.text = "Level "+str(n_level)
	$"SideBar/Status-container/Stat/Wave/wave-stat".text = "0/"+str(level.n_of_wave)
	$"SideBar/Status-container/Stat/Conf/conf-stat".text="[##########]"
	conf = 10
	$"SideBar/Status-container/Stat/Integ/integ-stat".text="[##########]"
	integ = 10
	$"SideBar/Status-container/Stat/Disp/disp-stat".text="[##########]"
	disp = 10

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

	for i in range(len(level.placable_defence_position)):
		var button = defence_button.instantiate()
		button.position = level.placable_defence_position[i]
		button.z_index = 1 
		playzone.add_child(button)
		defence_buttons.append(button)
	
	$PlayZone/BtcGen_stat.position = level.btc_gen_position
	$"SideBar/Status-container/Stat/BTC/BtcGen".start()
	$PlayZone/BtcGen_stat/AnimationPlayer.play("btc_gen")
	start_wave()

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
	var level = LevelDefiner.get_level(n_level_playing)
	var value = []
	value.append(level.get_upgrade_level_cost(type, defence_level))
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
	attack_spawned.append(new_attack)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if attack_spawned.find(body):
		body.entered_protected_node=true
