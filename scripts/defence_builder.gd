extends Panel

var defence: Button





func _on_build_firewall_pressed() -> void:
	defence.set_type("firewall")
	$".".visible=0


func _on_build_honeypot_pressed() -> void:
	defence.set_type("honeypot")
	$".".visible=0
