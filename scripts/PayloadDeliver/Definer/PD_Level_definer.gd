extends Node

var levels = [
	# Livello 1: Introduzione al TTL
	# Obiettivo: Consegnare il pacchetto prima che il TTL si esaurisca.
	# Nodi: Router, Switch. No Furtività.
	PD_level_class.new(
		0,  #! time (non utilizzato in questo livello)
		7,  # ttl (sufficiente per esplorare un po', percorso più breve ~4 hop)
		0, #! furtività (non usata nel primo livello)
		{
			"start_node_id": "START_L1",
			"target_node_id": "TARGET_L1",
			"nodes": {
				"START_L1": {"ip": "192.168.1.1", "type": "router", "connections": ["R1_L1"]}, # IP di partenza, rete locale
				"R1_L1":    {"ip": "172.16.5.10", "type": "router", "connections": ["START_L1", "S1_L1"]}, # Nodo di transizione verso un'altra classe di IP
				"S1_L1":    {"ip": "10.1.0.1",    "type": "switch", "connections": ["R1_L1", "R2_L1", "R3_L1"]}, # Switch. Target è 10.0.0.1. Giocatore deve notare il cambio nel secondo ottetto.
				"R2_L1":    {"ip": "10.0.1.10",   "type": "router", "connections": ["S1_L1", "TARGET_L1"]}, # Percorso corretto: 10.0.x.x è più vicino a 10.0.0.1
				"R3_L1":    {"ip": "10.1.2.20",   "type": "router", "connections": ["S1_L1"]}, # Vicolo cieco: 10.1.x.x è simile allo switch ma non al target.
				"TARGET_L1":{"ip": "10.0.0.1",    "type": "finish", "connections": ["R2_L1"]} # Nodo Target
			}
		}
	),
	# Livello 2: Introduzione alla Furtività
	# Obiettivo: Raggiungere il target gestendo TTL e Furtività.
	# Nodi aggiunti: Proxy, Firewall.
	PD_level_class.new(
		0,   # time (0 = non utilizzato)
		8,   # ttl (percorsi da 3 a 5 hop)
		100, # furtivita (iniziale)
		{
			"start_node_id": "START_L2",
			"target_node_id": "TARGET_L2",
			"nodes": {
				"START_L2": {"ip": "192.168.2.1", "type": "router", "connections": ["FW1_L2", "P1_L2"]}, # Partenza da una rete "locale"
				# Percorso Firewall: IP suggerisce una via diretta alla rete 10.0.x.x, ma è un Firewall (-20% Furtività)
				"FW1_L2":   {"ip": "10.0.50.2",   "type": "firewall", "connections": ["START_L2", "R1_L2"]}, 
				"R1_L2":    {"ip": "10.0.25.3",   "type": "router", "connections": ["FW1_L2", "TARGET_L2"]}, # IP progressivamente più vicino al target
				# Percorso Proxy: IP suggerisce un instradamento diverso (172.16.x.x), più lungo ma il Proxy aiuta la Furtività (+10%)
				"P1_L2":    {"ip": "172.16.10.4", "type": "proxy", "connections": ["START_L2", "R2_L2"]},    
				"R2_L2":    {"ip": "172.16.20.5", "type": "router", "connections": ["P1_L2", "S1_L2"]},
				"S1_L2":    {"ip": "172.16.30.6", "type": "switch", "connections": ["R2_L2", "R3_L2"]},
				"R3_L2":    {"ip": "10.0.75.7",   "type": "router", "connections": ["S1_L2", "TARGET_L2"]}, # Ritorno alla rete 10.0.x.x, ma terzo ottetto più "lontano" rispetto a R1_L2
				"TARGET_L2":{"ip": "10.0.1.1", "type": "finish", "connections": ["R1_L2", "R3_L2"]} # Nodo Target
			}
		}
	),
	# Livello 3: Mappa più complessa e HoneyPot
	# Obiettivo: Evitare trappole (HoneyPot) prestando attenzione agli IP.
	# Nodi aggiunti: HoneyPot. Più Switch.
	PD_level_class.new(
		0,   # time (0 = non utilizzato)
		12,  # ttl (un po' più alto per via degli HoneyPot e maggiore complessità)
		100, # furtivita
		{
			"start_node_id": "START_L3",
			"target_node_id": "TARGET_L3",
			"nodes": {
				"START_L3": {"ip": "192.168.3.1", "type": "router", "connections": ["S1_L3", "P1_L3"]},
				"S1_L3":    {"ip": "192.168.3.2", "type": "switch", "connections": ["START_L3", "R1_L3", "HP1_L3", "FW1_L3"]}, # Nodo centrale con opzioni
				"R1_L3":    {"ip": "192.168.3.3", "type": "router", "connections": ["S1_L3", "R2_L3"]}, # Percorso standard
				"HP1_L3":   {"ip": "172.16.111.1", "type": "honeypot", "connections": ["S1_L3", "R2_L3"]}, # ATTENZIONE: IP sospetto! -10% Furtività, -3 TTL
				"FW1_L3":   {"ip": "192.168.3.4", "type": "firewall", "connections": ["S1_L3", "TARGET_L3"]}, # Scorciatoia rischiosa
				"P1_L3":    {"ip": "192.168.3.5", "type": "proxy", "connections": ["START_L3", "S2_L3"]},    # Percorso alternativo più sicuro
				"S2_L3":    {"ip": "192.168.3.6", "type": "switch", "connections": ["P1_L3", "R2_L3", "R3_L3"]},
				"R2_L3":    {"ip": "192.168.3.7", "type": "router", "connections": ["R1_L3", "HP1_L3", "S2_L3", "R4_L3"]}, # Nodo di convergenza
				"R3_L3":    {"ip": "192.168.3.8", "type": "router", "connections": ["S2_L3", "R4_L3"]},
				"R4_L3":    {"ip": "192.168.3.9", "type": "router", "connections": ["R2_L3", "R3_L3", "TARGET_L3"]},
				"TARGET_L3":{"ip": "10.0.2.1", "type": "router", "connections": ["FW1_L3", "R4_L3"]} # Nodo Target
			}
		}
	),
	# Livello 4: Gestione del tempo e pressione finale
	# Obiettivo: Bilanciare TTL, Furtività e Tempo globale.
	# Nodi aggiunti: Rate Limiter.
	PD_level_class.new(
		60,  # time (es. 60 secondi/unità di tempo)
		15,  # ttl (mappa più grande e complessa)
		100, # furtivita
		{
			"start_node_id": "START_L4",
			"target_node_id": "TARGET_L4",
			"nodes": {
				"START_L4":     {"ip": "192.168.4.1", "type": "router", "connections": ["S_ENTRY_L4"]},
				"S_ENTRY_L4":   {"ip": "192.168.4.2", "type": "switch", "connections": ["START_L4", "P1_L4", "RL1_L4", "FW1_L4"]}, # Primo bivio importante

				# Percorso "Proxy" (più lungo, più sicuro per furtività, più consumo TTL)
				"P1_L4":        {"ip": "192.168.4.3", "type": "proxy", "connections": ["S_ENTRY_L4", "R_SAFE_1_L4"]},
				"R_SAFE_1_L4":  {"ip": "192.168.4.4", "type": "router", "connections": ["P1_L4", "S_SAFE_L4"]},
				"S_SAFE_L4":    {"ip": "192.168.4.5", "type": "switch", "connections": ["R_SAFE_1_L4", "R_SAFE_2_L4", "HP_SAFE_L4"]},
				"R_SAFE_2_L4":  {"ip": "192.168.4.6", "type": "router", "connections": ["S_SAFE_L4", "R_CONVERGE_L4"]},
				"HP_SAFE_L4":   {"ip": "10.10.222.1", "type": "honeypot", "connections": ["S_SAFE_L4", "R_CONVERGE_L4"]}, # HoneyPot su un percorso "sicuro" (IP sospetto)

				# Percorso "Rate Limiter" (veloce, penalità tempo e furtività)
				"RL1_L4":       {"ip": "192.168.4.7", "type": "ratelimiter", "connections": ["S_ENTRY_L4", "R_FAST_1_L4"]}, # -10% Furtività, riduce tempo globale
				"R_FAST_1_L4":  {"ip": "192.168.4.8", "type": "router", "connections": ["RL1_L4", "R_CONVERGE_L4"]},

				# Percorso "Firewall" (veloce, penalità furtività)
				"FW1_L4":       {"ip": "192.168.4.9", "type": "firewall", "connections": ["S_ENTRY_L4", "S_RISKY_L4"]}, # -20% Furtività
				"S_RISKY_L4":   {"ip": "192.168.4.10", "type": "switch", "connections": ["FW1_L4", "HP_RISKY_L4", "R_CONVERGE_L4"]},
				"HP_RISKY_L4":  {"ip": "172.20.3.444", "type": "honeypot", "connections": ["S_RISKY_L4", "R_CONVERGE_L4"]}, # HoneyPot su percorso rischioso (IP sospetto)

				# Nodi di convergenza e finali
				"R_CONVERGE_L4":{"ip": "192.168.4.11", "type": "router", "connections": [ # Nodo che raccoglie più percorsi
																	"R_SAFE_2_L4", "HP_SAFE_L4",
																	"R_FAST_1_L4",
																	"S_RISKY_L4", "HP_RISKY_L4",
																	"S_FINAL_L4"
																	]},
				"S_FINAL_L4":   {"ip": "192.168.4.12", "type": "switch", "connections": ["R_CONVERGE_L4", "TARGET_L4"]},
				"TARGET_L4":    {"ip": "10.0.3.1", "type": "router", "connections": ["S_FINAL_L4"]} # Nodo Target
			}
		}
	)
]
