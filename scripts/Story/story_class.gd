extends Node

class_name Storia
var scene_id: String
var scene_name: String
var text: String
var visited: bool = false

func _init(new_scene_id: String, new_scene_name:String, new_text:String) -> void:
	self.scene_id = new_scene_id
	self.scene_name = new_scene_name
	self.text = new_text
	
func get_scene_id() -> String:
	return self.scene_id

func get_scene_text() -> String:
	return self.text

func get_scene_name() -> String:
	return self.scene_name

func set_visited():
	self.visited = true

func get_visited():
	return self.visited
