extends Node



var conf := 0
var integ := 0
var disp := 0


func _ready():
	if Global.save_data["settings"]["crt"] == false:
		$CanvasLayer.visible = false
	
	level_1()


func level_1() -> void:
	$TerminalBar/StatusBar/Level.text= "LEVEL 1"
	$"SideBar/Status-container/Stat/Wave/wave-stat".text = "0/5"
	$"SideBar/Status-container/Stat/Conf/conf-stat".text="[##########]"
	conf = 10
	$"SideBar/Status-container/Stat/Integ/integ-stat".text="[##########]"
	integ = 10
	$"SideBar/Status-container/Stat/Disp/disp-stat".text="[##########]"
	disp = 10
	$"SideBar/Status-container/Stat/BTC/Btc-stat".text="0"
	
	$SideBar/PassiveDef/Stat/Patch/Status.text = "❌ - [0]"
	$SideBar/PassiveDef/Stat/Patch/level.text = "0 - 0 ₿"
	
	$SideBar/PassiveDef/Stat/Antivirus/Status.text = "❌ - [0]"
	$SideBar/PassiveDef/Stat/Antivirus/level.text="0 - 0 ₿"
	
	$SideBar/PassiveDef/Stat/SocialEngeneering/Status.text = "❌ - [0]"
	$SideBar/PassiveDef/Stat/SocialEngeneering/level.text="0 - 0 ₿"
	
	$PlayZone/Defence_1.position = Vector2(207.0, 227.0)
	
