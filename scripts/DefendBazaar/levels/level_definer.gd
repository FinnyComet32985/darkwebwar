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
            "firewall": [0, 3, 6],
            "honeypot": [0, 1, 3],
            "ids": [0, 3, 6],
            "ratelimiter": [0, 2, 7]
            # altro
        },
        "res://assets/temp/DarkWebWar-Level 1.png",
        { # posizione strutture
        0: Vector2(207.0, 227.0),
        1: Vector2(319, 227),
        2: Vector2(431, 227),
        3: Vector2(319, 339)
        }
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
            "rateLimiter": [2, 7]
            # altro
        },
        "res://assets/temp/DarkWebWar-Level 2.png",
        { # posizione strutture
        0: Vector2(207.0, 227.0),
        1: Vector2(319, 227),
        2: Vector2(431, 227),
        3: Vector2(319, 339),
        4: Vector2(431, 339)
        }
    )
]


func get_level(levelNum: int) -> LevelClass:
    return levels[levelNum-1]