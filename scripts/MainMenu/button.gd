extends Button

@export var scene_id: String


func set_scene_id(id):
	scene_id = id


func _ready():
	connect("focus_entered", Callable(self, "_on_focus_entered"))
	connect("focus_exited", Callable(self, "_on_focus_exited"))
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_focus_entered():
	start_animation(self.name)

func _on_focus_exited():
	stop_animation(self.name)

func _on_mouse_entered():
	start_animation(self.name)

func _on_mouse_exited():
	stop_animation(self.name)


func start_animation(button)-> void:
	if button == "Button":
		$"../Label/AnimationPlayer".play("focussed")
	elif button == "Button2":
		$"../../HBoxContainer2/Label/AnimationPlayer".play("focussed")
	elif  button == "Button3":
		$"../../HBoxContainer3/Label/AnimationPlayer".play("focussed")
	elif button == "Button4":
		$"../../HBoxContainer4/Label/AnimationPlayer".play("focussed")
	elif button == "Button5":
		$"../../HBoxContainer5/Label/AnimationPlayer".play("focussed")
	elif button == "Button6":
		$"../../HBoxContainer6/Label/AnimationPlayer".play("focussed")

func stop_animation(button)-> void:
	if button == "Button":
		$"../Label/AnimationPlayer".play("RESET")
	elif button == "Button2":
		$"../../HBoxContainer2/Label/AnimationPlayer".play("RESET")
	elif  button == "Button3":
		$"../../HBoxContainer3/Label/AnimationPlayer".play("RESET")
	elif button == "Button4":
		$"../../HBoxContainer4/Label/AnimationPlayer".play("RESET")
	elif button == "Button5":
		$"../../HBoxContainer5/Label/AnimationPlayer".play("RESET")
	elif button == "Button6":
		$"../../HBoxContainer6/Label/AnimationPlayer".play("RESET")
