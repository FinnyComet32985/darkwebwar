extends Node

class_name DB_Icons

static var defence = {
	"Firewall": preload("res://assets/DefendBazaar/defences/DarkWebWar-Firewall.svg"),
	"WAF": preload("res://assets/DefendBazaar/defences/DarkWebWar-WAF.svg"),
	"IDS": preload("res://assets/DefendBazaar/defences/DarkWebWar-IDS.svg"),
	"Rate Limiter": preload("res://assets/DefendBazaar/defences/DarkWebWar-RateLimiter.svg")
}

static var attack = {
	"DDoS": preload("res://assets/DefendBazaar/attacks/DarkWebWar-DDoS.svg"),
	"Port scanning": preload("res://assets/DefendBazaar/attacks/DarkWebWar-PortScanning.svg"),
	"Banner grabbing": preload("res://assets/DefendBazaar/attacks/DarkWebWar-BannerGrab.svg"),
	"Path trasversal": preload("res://assets/DefendBazaar/attacks/DarkWebWar-PathTrasversal.svg")
}


static func load_icon(type: String) -> Resource:
	if defence.has(type):
		return defence[type]
	elif attack.has(type):
		return attack[type]
	else:
		print("error loading icon")
		return null
