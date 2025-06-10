extends Panel

var web_node = preload("res://scenes/PayloadDeliver/web_node.tscn")
var line_scene = preload("res://scenes/PayloadDeliver/line.tscn")

var icons = {
	"router": preload("res://assets/temp/router.png"),
	"switch": preload("res://assets/RithmForce/web_node/DarkWebWar-Switch.svg"),
	"proxy": preload("res://assets/RithmForce/web_node/DarkWebWar-Proxy.svg"),
	"firewall": preload("res://assets/DefendBazaar/defences/DarkWebWar-Firewall.svg"),
	"honeypot": preload("res://assets/temp/router.png"),
	"ratelimiter": preload("res://assets/DefendBazaar/defences/DarkWebWar-RateLimiter.svg")
}


var level
var n_level = 0

var ttl:= 0
var furtivita := 0

func _ready():
	init_level()

func _process(_delta: float) -> void:
	if $GameTimer != null && $GameTimer.is_stopped() == false:
		$"Status-container/Stat/RemaningTime/remaning-time-stat".text = str(int($GameTimer.time_left)) + " s"

func init_level():
	get_tree().create_timer(3)
	$StatusBar/Level.text = "LEVEL " + str(n_level+1)
	level = PD_Level_definer.levels[n_level]
	if level.time != 0:
		$"Status-container/Stat/RemaningTime".visible = true
		$GameTimer.wait_time = level.time
		$GameTimer.start()
	else:
		$"Status-container/Stat/RemaningTime".visible = false
	$"Status-container/Stat/TargetSec/target-stat".text = level.map["nodes"][level.map["target_node_id"]]["ip"]
	ttl = level.ttl
	$"Status-container/Stat/TTLSec/ttl-stat".text = str(level.ttl)
	if level.furtivita != 0:
		$"Status-container/Stat/FurtSec".visible = true
		$"Status-container/Stat/FurtSec/furt-stat".text = str(level.furtivita)
		furtivita = level.furtivita
	else:
		$"Status-container/Stat/FurtSec".visible = false
	set_current_node(level.map["start_node_id"])
	set_next_nodes(level.map["start_node_id"])

func set_current_node(node_id: String):
	$PlayZone/CurrentNode/TextureRect.texture = icons[level.map["nodes"][node_id]["type"]]
	$PlayZone/CurrentNode/IP.text = level.map["nodes"][node_id]["ip"]

func game_over():
	print("GAME OVER")

var lines = []

func set_next_nodes(node_id: String):
	for child in $"./PlayZone/PossibleNextNode".get_children():
		$"./PlayZone/PossibleNextNode".remove_child(child)
		child.queue_free()

	var next_nodes = level.map["nodes"][node_id]["connections"]
	for db_node in next_nodes:
		var node = web_node.instantiate()
		node.init(db_node, level.map["nodes"][db_node]["ip"], level.map["nodes"][db_node]["type"])
		$PlayZone/PossibleNextNode.add_child(node)

	await get_tree().process_frame
	await get_tree().process_frame

	for line in lines:
		line.queue_free()
	lines = []


	for child in $PlayZone/PossibleNextNode.get_children():
		var line = line_scene.instantiate()
		line.posit(Vector2(341.0, 350.0), Vector2(child.global_position.x, child.global_position.y+20))
		$PlayZone.add_child(line)
		lines.append(line)

func update_ttl(type: String):
	var dim = 3 if type == "honeypot" else 1

	if ttl-dim > 0:
		ttl -= dim
		$"Status-container/Stat/TTLSec/ttl-stat".text = str(ttl)
	else:
		game_over()

func update_furt(type: String):
	var dim = 0
	match type:
		"proxy":
			dim = 10
		"firewall":
			dim = -20
		"ratelimiter":
			dim = -10
		"honeypot":
			dim = -10

	if furtivita+dim > 0:
		furtivita += dim
		$"Status-container/Stat/FurtSec/furt-stat".text = str(furtivita)
	else:
		game_over()

func update_game_timer():
	if $GameTimer.wait_time-5 > 0:
		$GameTimer.wait_time -= 5
	else:
		game_over()

func update_game_ttl() -> void:
	if ttl-3 > 0:
		ttl -= 3

func _on_game_timer_timeout() -> void:
	game_over()
