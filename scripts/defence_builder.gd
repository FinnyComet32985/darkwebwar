extends Panel

var defence: Button

func _on_build_firewall_pressed() -> void:
	defence.set_type("firewall")
	$".".visible=0

func _on_build_honeypot_pressed() -> void:
	defence.set_type("honeypot")
	$".".visible=0


func _on_build_ids_pressed() -> void:
	defence.set_type("ids")
	$".".visible=0

func _on_build_rate_limiter_pressed() -> void:
	defence.set_type("ratelimiter")
	$".".visible=0

func _on_back_button_pressed() -> void:
	$".".visible=0


func _on_visibility_changed() -> void:
	if $".".visible == true:
		if $"../..".defence_built.find("firewall")!=-1:
			$ScrollContainer/defence/Firewall.visible = 0
		if $"../..".defence_built.find("honeypot")!=-1:
			$ScrollContainer/defence/HoneyPot.visible = 0
		if $"../..".defence_built.find("ids")!=-1:
			$ScrollContainer/defence/Ids.visible = 0
		if $"../..".defence_built.find("ratelimiter")!=-1:
			$ScrollContainer/defence/RateLimiter.visible = 0
