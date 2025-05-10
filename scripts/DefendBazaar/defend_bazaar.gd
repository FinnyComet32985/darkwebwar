extends Node

signal level_up_requested

var defence_button = preload("res://scenes/DefendBazaar/defence_button.tscn")

var conf := 0
var integ := 0
var disp := 0

var defence_buttons := []

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
	$"SideBar/Status-container/Stat/BTC/Btc-stat".text="0"
	
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
	

func _on_level_up_requested():
	n_level_playing += 1
	for i in defence_buttons:
		i.queue_free()
	init_level(n_level_playing)



func request_level_up():
	emit_signal("level_up_requested")
