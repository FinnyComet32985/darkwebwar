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

func _on_button_pressed() -> void:
	$".".visible=0
