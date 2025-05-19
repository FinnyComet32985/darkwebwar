extends Panel

var defence: Button

func _on_build_firewall_pressed() -> void:
	$"../..".btc=$"../..".btc-$"../..".get_defence_other_info("firewall", 0)[0]
	$"../../".update_btc()
	defence.set_type("firewall")
	defence.update_path()
	$".".visible=0

func _on_build_honeypot_pressed() -> void:
	$"../..".btc=$"../..".btc-$"../..".get_defence_other_info("honeypot", 0)[0]
	$"../../".update_btc()
	defence.set_type("honeypot")
	defence.update_path()
	$".".visible=0


func _on_build_ids_pressed() -> void:
	$"../..".btc=$"../..".btc-$"../..".get_defence_other_info("ids", 0)[0]
	$"../../".update_btc()
	defence.set_type("ids")
	defence.update_path()
	$".".visible=0

func _on_build_rate_limiter_pressed() -> void:
	$"../..".btc=$"../..".btc-$"../..".get_defence_other_info("Rate Limiter", 0)[0]
	$"../../".update_btc()
	defence.set_type("Rate Limiter")
	defence.update_path()
	$".".visible=0

func _on_back_button_pressed() -> void:
	$".".visible=0


func _on_visibility_changed() -> void:
	if $".".visible == true:
		# check if the defence is already built
		if $"../..".defence_built.find("firewall")!=-1:
			$ScrollContainer/defence/Firewall.visible = 0
		else:
			$ScrollContainer/defence/Firewall/Cost.text=str($"../..".get_defence_other_info("firewall", 0)[0])+" ₿"
		if $"../..".defence_built.find("honeypot")!=-1:
			$ScrollContainer/defence/HoneyPot.visible = 0
		else:
			$ScrollContainer/defence/HoneyPot/Cost.text=str($"../..".get_defence_other_info("honeypot", 0)[0])+" ₿"
		if $"../..".defence_built.find("ids")!=-1:
			$ScrollContainer/defence/Ids.visible = 0
		else:
			$ScrollContainer/defence/Ids/Cost.text=str($"../..".get_defence_other_info("ids", 0)[0])+" ₿"
		if $"../..".defence_built.find("Rate Limiter")!=-1:
			$ScrollContainer/defence/RateLimiter.visible = 0
		else:
			$ScrollContainer/defence/RateLimiter/Cost.text=str($"../..".get_defence_other_info("Rate Limiter", 0)[0])+" ₿"

		# check if have the money to build
		if $"../..".get_defence_other_info("firewall", 0)[0] > $"../..".btc:
			$ScrollContainer/defence/Firewall/BuildFirewall.visible=false
		if $"../..".get_defence_other_info("honeypot", 0)[0] > $"../..".btc:
			$ScrollContainer/defence/HoneyPot/BuildHoneypot.visible=false
		if $"../..".get_defence_other_info("ids", 0)[0] > $"../..".btc:
			$ScrollContainer/defence/Ids/BuildIDS.visible=false
		if $"../..".get_defence_other_info("Rate Limiter", 0)[0] > $"../..".btc:
			$ScrollContainer/defence/RateLimiter/BuildRateLimiter.visible=false
