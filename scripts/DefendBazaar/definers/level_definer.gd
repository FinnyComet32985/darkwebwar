extends Node

var levels := [
	# Level 1
	LevelClass.new(
		1, # numero di livello
		3, # numero di ondate
		{ # costi per le difese statiche 
		"patch": [0],
		"antivirus": [0],
		"phishingRecognizer": [0]
		},
		{ # costi per upgrade edifici piazzabili 
			"firewall": [1, 3, 6],
			"honeypot": [2, 1, 3],
			"ids": [1, 3, 6],
			"Rate Limiter": [3, 2, 7]
			# altro
		},
		"res://assets/temp/DarkWebWar-Level 1.png",

		#TODO path
		[
			[ # path 1
				Web_node.new("defence", Vector2(207.0, 227.0), [Vector2(378, 218), Vector2(269, 305)]),
				Web_node.new("transaction_server", Vector2(237, 373), [Vector2(265, 377), Vector2(265, 427)])
			],
			[ # path 2
				Web_node.new("defence", Vector2(319, 227), [Vector2(377, 251), Vector2(377, 308)]),
				Web_node.new("defence", Vector2(431, 227), [Vector2(377, 251), Vector2(377, 293)]),
				Web_node.new("backend", Vector2(346, 482), [Vector2(377, 251), Vector2(377, 303)])
			],
			[ # path 3
				Web_node.new("defence", Vector2(319, 339), [Vector2(381, -18), Vector2(485, 74)]),
				Web_node.new("defence_c", Vector2(431, 227), [Vector2(490, 137), Vector2(414, 204)]),
				Web_node.new("backend_c", Vector2(446, 482), [Vector2(377, 251), Vector2(377, 303)])
			]
		],
		[
			AttackClass.new("DDoS", ["firewall"], ["backend"], 30)
		]
	),
	# Level 2
	LevelClass.new(
		2, # numero di livello
		3, # numero di ondate
		{ # costi per le difese statiche 
		"patch": [0],
		"antivirus": [0],
		"phishingRecognizer": [0]
		},
		{ # costi per upgrade edifici piazzabili 
			"firewall": [3, 6],
			"honeypot": [1, 3],
			"ids": [3, 6],
			"Rate Limiter": [2, 7]
			# altro
		},
		"res://assets/temp/DarkWebWar-Level 2.png",
		
		
		[

		],
		[
			AttackClass.new("DDoS", ["firewall"], ["backend"], 30)
		]
	)
]


func get_level(levelNum: int) -> LevelClass:
	return levels[levelNum-1]

func get_prefered_target(level: int, attack_type: String) -> Array:
	var attacks = levels[level-1].attacks
	var find = attacks.filter(func(attack): return attack.attack_type == attack_type)
	return find[0].prefered_target

func find_path(level:int, structure_name:String) -> Array:
	var structure_name_c = structure_name+"_c"
	var return_path = []
	for path in levels[level-1].paths:
		for node in path:
			if node.type == structure_name || node.type==structure_name_c:
				return_path.append(path)
	return return_path
