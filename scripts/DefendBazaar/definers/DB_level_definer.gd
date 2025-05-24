extends Node

var levels := [
	# Level 1
	DB_Level_class.new(
		1, # numero di livello
		[
			DB_static_defence_class.new("Patch", 20, 10, [10, 20, 30], [0, 2, 3, 4 ]),
			DB_static_defence_class.new("Phishing", 20, 10, [10, 20, 30], [0, 2, 3, 4]),
			DB_static_defence_class.new("Antivirus", 20, 10, [10, 20, 30], [[0, 1, 1], [0, 2, 3]])
		],
		{ # costi per upgrade edifici piazzabili 
			"Firewall": [1, 3, 6, 0],
			"WAF": [2, 1, 3, 0],
			"IDS": [1, 3, 6, 0],
			"Rate Limiter": [3, 2, 7, 0]
			# altro
		},
		"res://assets/DefendBazaar/levels/DarkWebWar-Level 1.svg",
		[
			[ # path 1
				DB_Web_node.new(1, "defence", Vector2(207.0, 227.0), [Vector2(378, 218), Vector2(269, 305)]),
				DB_Web_node.new(2, "transaction_server", Vector2(237, 373), [Vector2(265, 377), Vector2(265, 427)])
			],
			[ # path 2
				DB_Web_node.new(3, "defence", Vector2(319, 227), [Vector2(380, 219), Vector2(380, 310)]),
				DB_Web_node.new(4, "defence", Vector2(319, 339), [Vector2(380, 372), Vector2(380, 424)]),
				DB_Web_node.new(5, "file_server", Vector2(346, 482), [Vector2(380, 483), Vector2(380, 541)])
			],
			[ # path 3 
				DB_Web_node.new(6, "defence", Vector2(431, 227), [Vector2(386, 221), Vector2(488, 312)]),
				DB_Web_node.new(4, "defence_c", Vector2(319, 339), [Vector2(493, 373), Vector2(408, 444)]),
				DB_Web_node.new(5, "file_server_c", Vector2(446, 482), [Vector2(380, 483), Vector2(380, 541)])
			]
		],
		[
			DB_Attack_class.new("Port scanning", {"Firewall": [10, 15, 20], "IDS": [20, 25], "Rate Limiter": [5, 10] }, 30, {"transaction_server": [1, 0, 0], "file_server": [1, 0, 0]}), 
			DB_Attack_class.new("Banner grabbing", {"Firewall": [20, 30, 30]}, 30, {"transaction_server": [1, 0, 0], "file_server": [1, 0, 0]}),
			DB_Attack_class.new("Path trasversal", {"WAF": [20, 25, 30]}, 30, {"file_server": [3, 2, 1]}),
			DB_Attack_class.new("DDoS", {"Firewall": [10, 15, 20], "Rate Limiter": [20]}, 30, {"transaction_server": [0, 0, 2], "file_server": [0, 0, 2]}),
		],
		{ # ondate
			0: [0, 10],
			1: [30, 15], # n_ondata: [ durata ondata, timer alla prossima ondata ]
			2: [40, 20],
			3: [50, 20],
			4: [60, 20]
		},
		{
			"0 day": [
				DB_critical_attack_class.new("Ramsomware", "Un ransomware sofisticato sfrutta la vulnerabilità 0-day per criptare immediatamente i dati critici sui file server principali, bypassando tutte le difese perimetrali convenzionali.", [0, 1, 3], [1, 10]),
				DB_critical_attack_class.new("Worm Autopropagante", "Un malware che sfrutta la vulnerabilità 0-day per diffondersi automaticamente attraverso la rete, infettando progressivamente tutti i sistemi collegati.", [1, 2, 3], [1, 10]),
				DB_critical_attack_class.new("Memory Corruption Attack", "La vulnerabilità 0-day causa corruzione della memoria sui server di elaborazione, portando a crash di sistema e perdita di dati in elaborazione.", [1, 3, 3], [1, 10])
			],
			"Social Engineering": [
				DB_critical_attack_class.new("Insider Data Breach", "Un dipendente compromesso dal social engineering ha fornito accesso diretto ai database contenenti informazioni sensibili. I dati vengono esfiltrati senza lasciare tracce evidenti.", [4, 0, 0], [1, 10]),
				DB_critical_attack_class.new("Credential Harvesting", "Gli attaccanti hanno ottenuto le credenziali di accesso di diversi utenti chiave attraverso phishing mirato. Utilizzano questi accessi per compromettere i sistemi di autenticazione.", [3, 3, 1], [1, 10]),
				DB_critical_attack_class.new("Business Email Compromise", "Gli attaccanti hanno compromesso la casella email di un dirigente e stanno utilizzando questo accesso per autorizzare transazioni fraudolente e diffondere malware all'interno dell'organizzazione.", [3, 2, 2], [1, 10])
			]
		}
	),
	# Level 2
	DB_Level_class.new(
		2, # numero di livello
		[],
		# { # costi per le difese statiche 
		# "patch": [0],
		# "antivirus": [0],
		# "phishingRecognizer": [0]
		# },
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
			DB_Attack_class.new("DDoS", {"firewall": 30}, 30, {"backend": [0, 0, 20]})
		],
				{
			1: [30, 20],
			2: [40, 20]
		},
		{
			"0 day": [
				DB_critical_attack_class.new("Ramsomware", "Un ransomware sofisticato sfrutta la vulnerabilità 0-day per criptare immediatamente i dati critici sui file server principali, bypassando tutte le difese perimetrali convenzionali.", [0, 1, 3], [1, 10]),
				DB_critical_attack_class.new("Worm Autopropagante", "Un malware che sfrutta la vulnerabilità 0-day per diffondersi automaticamente attraverso la rete, infettando progressivamente tutti i sistemi collegati.", [1, 2, 3], [1, 10]),
				DB_critical_attack_class.new("Memory Corruption Attack", "La vulnerabilità 0-day causa corruzione della memoria sui server di elaborazione, portando a crash di sistema e perdita di dati in elaborazione.", [1, 3, 3], [1, 10])
			],
			"Social Engineering": [
				DB_critical_attack_class.new("Insider Data Breach", "Un dipendente compromesso dal social engineering ha fornito accesso diretto ai database contenenti informazioni sensibili. I dati vengono esfiltrati senza lasciare tracce evidenti.", [4, 0, 0], [1, 10]),
				DB_critical_attack_class.new("Credential Harvesting", "Gli attaccanti hanno ottenuto le credenziali di accesso di diversi utenti chiave attraverso phishing mirato. Utilizzano questi accessi per compromettere i sistemi di autenticazione.", [3, 3, 1], [1, 10]),
				DB_critical_attack_class.new("Business Email Compromise", "Gli attaccanti hanno compromesso la casella email di un dirigente e stanno utilizzando questo accesso per autorizzare transazioni fraudolente e diffondere malware all'interno dell'organizzazione.", [3, 2, 2], [1, 10])
			]
		}
	)
]


func get_level(levelNum: int) -> DB_Level_class:
	return levels[levelNum-1]
