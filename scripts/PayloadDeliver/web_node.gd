extends Button

var icons = {
	"router": preload("res://assets/temp/router.png"),
	"switch": preload("res://assets/RithmForce/web_node/DarkWebWar-Switch.svg"),
	"proxy": preload("res://assets/RithmForce/web_node/DarkWebWar-Proxy.svg"),
	"firewall": preload("res://assets/DefendBazaar/defences/DarkWebWar-Firewall.svg"),
	"honeypot": preload("res://assets/temp/Honeypot.png"),
	"ratelimiter": preload("res://assets/DefendBazaar/defences/DarkWebWar-RateLimiter.svg"),
	"finish": preload("res://assets/RithmForce/web_node/DarkWebWar-Finish.svg")
}


var id: String
var ip: String
var type: String

func init(_id: String, _ip: String, _type: String) -> void:
	id = _id
	ip = _ip
	type = _type
	set_attributes()

func set_attributes() -> void:
	$".".icon = icons[type]
	$IP.text = ip


func _on_pressed() -> void:
	if id == get_tree().current_scene.level.map["target_node_id"]:
		get_tree().current_scene.get_node("win").play()
		get_tree().current_scene.n_level += 1
		get_tree().current_scene.init_level()
	else:
		get_tree().current_scene.update_ttl(type)
		if type != "router" && type != "switch" :
			get_tree().current_scene.update_furt(type)
		if type == "ratelimiter":
			get_tree().current_scene.update_game_timer()
		if type == "honeypot":
			get_tree().current_scene.update_game_ttl()
			get_tree().current_scene.update_furt("honeypot")
		get_tree().current_scene.set_current_node(id)
		if type == "honeypot" || type == "firewall":
			get_tree().current_scene.get_node("next_negative").play()
		else: 
			get_tree().current_scene.get_node("next").play()
		get_tree().current_scene.set_next_nodes(id)
