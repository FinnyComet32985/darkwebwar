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
				Web_node.new(1, "defence", Vector2(207.0, 227.0), [Vector2(378, 218), Vector2(269, 305)]),
				Web_node.new(2, "transaction_server", Vector2(237, 373), [Vector2(265, 377), Vector2(265, 427)])
			],
			[ # path 2
				Web_node.new(3, "defence", Vector2(319, 227), [Vector2(377, 219), Vector2(377, 310)]),
				Web_node.new(4, "defence", Vector2(319, 339), [Vector2(377, 372), Vector2(377, 424)]),
				Web_node.new(5, "backend", Vector2(346, 482), [Vector2(377, 483), Vector2(377, 541)])
			],
			[ # path 3 
				Web_node.new(6, "defence", Vector2(431, 227), [Vector2(386, 221), Vector2(488, 312)]),
				Web_node.new(4, "defence_c", Vector2(319, 339), [Vector2(493, 373), Vector2(408, 444)]),
				Web_node.new(5, "backend_c", Vector2(446, 482), [Vector2(377, 483), Vector2(377, 541)])
			]
		],
		[
			AttackClass.new("DDoS", ["firewall", "Rate Limiter"], ["backend"], 30),
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

func get_effective_defence(level:int, attack_type: String) -> Array:
	var attacks = levels[level-1].attacks
	var find = attacks.filter(func(attack): return attack.attack_type == attack_type)
	return find[0].attack_defence
