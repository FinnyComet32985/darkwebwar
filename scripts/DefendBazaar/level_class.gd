extends Node

class_name LevelClass
var level_num: int
var n_of_wave: int
var static_defence_level_cost: Dictionary
# {
#     "patch": [0, 10, ...], index = level, value = cost
#     "antivirus": [0, 7],
#     "phishingRecognizer": [0, 10]
# }
var placable_defence_level_cost: Dictionary
# {
#     "firewall":{
#         0:0
#     },
#     "honeypot":{
#         0:0
#     },
#     "ids":{
#         0:0
#     },
#     "rateLimiter": {
#         0:0
#     }
#     # altro
# }
var minimap: String # path to minimap

var placable_defence_position: Dictionary # { int: Vector2}

func _init(new_level_num: int, new_n_of_wave: int, new_static_defence_level_cost, new_placable_defence_level_cost, new_minimap, new_placable_defence_position) -> void:
    self.level_num = new_level_num
    self.n_of_wave = new_n_of_wave
    self.static_defence_level_cost = new_static_defence_level_cost
    self.placable_defence_level_cost = new_placable_defence_level_cost
    self.minimap = new_minimap
    self.placable_defence_position = new_placable_defence_position