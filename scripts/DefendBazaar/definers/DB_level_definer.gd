extends Node

var levels := [
	# Level 1
	DB_Level_class.new(
		1, # numero di livello
		3, # numero di ondate
		{ # costi per le difese statiche 
		"patch": [0],
		"antivirus": [0],
		"phishingRecognizer": [0]
		},
		{ # costi per upgrade edifici piazzabili 
			"Firewall": [1, 3, 6],
			"WAF": [2, 1, 3],
			"IDS": [1, 3, 6],
			"Rate Limiter": [3, 2, 7]
			# altro
		},
		"res://assets/temp/DarkWebWar-Level 1.png",

		#TODO path
		[
			[ # path 1
				DB_Web_node.new(1, "defence", Vector2(207.0, 227.0), [Vector2(378, 218), Vector2(269, 305)]),
				DB_Web_node.new(2, "transaction_server", Vector2(237, 373), [Vector2(265, 377), Vector2(265, 427)])
			],
			[ # path 2
				DB_Web_node.new(3, "defence", Vector2(319, 227), [Vector2(377, 219), Vector2(377, 310)]),
				DB_Web_node.new(4, "defence", Vector2(319, 339), [Vector2(377, 372), Vector2(377, 424)]),
				DB_Web_node.new(5, "file_server", Vector2(346, 482), [Vector2(377, 483), Vector2(377, 541)])
			],
			[ # path 3 
				DB_Web_node.new(6, "defence", Vector2(431, 227), [Vector2(386, 221), Vector2(488, 312)]),
				DB_Web_node.new(4, "defence_c", Vector2(319, 339), [Vector2(493, 373), Vector2(408, 444)]),
				DB_Web_node.new(5, "file_server_c", Vector2(446, 482), [Vector2(377, 483), Vector2(377, 541)])
			]
		],
		[
			DB_Attack_class.new("Port scanning", ["Firewall", "IDS"], 30, {"transaction_server": [1, 0, 0], "file_server": [1, 0, 0]}), 
			DB_Attack_class.new("Banner grabbing", ["Firewall"], 30, {"transaction_server": [1, 0, 0], "file_server": [1, 0, 0]}),
			DB_Attack_class.new("Path trasversal", ["WAF"], 30, {"file_server": [3, 2, 1]}),
			DB_Attack_class.new("DDoS", ["Firewall", "Rate Limiter"], 30, {"transaction_server": [0, 0, 2], "file_server": [0, 0, 2]}),
		]
	),
	# Level 2
	DB_Level_class.new(
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
			DB_Attack_class.new("DDoS", ["firewall"], 30, {"backend": [0, 0, 20]})
		]
	)
]


func get_level(levelNum: int) -> DB_Level_class:
	return levels[levelNum-1]

func get_prefered_target(level: int, attack_type: String) -> Array:
	var attacks = levels[level-1].attacks

	for attack in attacks:
		if attack_type == attack.attack_type:
			return attack.damage.keys()
	return []

func get_effective_defence(level:int, attack_type: String) -> Array:
	var attacks = levels[level-1].attacks
	var find = attacks.filter(func(attack): return attack.attack_type == attack_type)
	return find[0].attack_defence

func get_damage(level: int, attack_type: String, structure_type: String) -> Array:
	var attacks = levels[level-1].attacks
	for attack in attacks:
		if attack_type == attack.attack_type:
			if structure_type in attack.damage:
				return attack.damage[structure_type]
	return []
