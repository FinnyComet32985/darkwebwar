extends Node

class_name Web_node
var type: String
var position: Vector2
var curve: Curve2D

func _init(new_type:String, new_position:Vector2, new_curve:Array) -> void:
    self.type = new_type
    self.position = new_position
    var tmp_curve = Curve2D.new()
    tmp_curve.add_point(new_curve[0])
    tmp_curve.add_point(new_curve[1])
    self.curve = tmp_curve