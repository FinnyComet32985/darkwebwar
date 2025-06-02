extends Node

var levels = [
	# Livello 0: "Primi Passi nell'Ombra" (Comune/Tutorial)
	# Obiettivo: Introdurre le meccaniche base (navigazione, lettura, decisione raccogli/mantieni, mimetizzazione).
	# Contesto: Alex ha appena ricevuto l'invito da DK e sta muovendo i primi passi.
	LG_Level_class.new(
		180, # game time (secondi)
		60,  # scan_timer (secondi)
		{ # file_system
			"system_boot.log": {
				"type": "log",
				"delete": false,
				"content": "System v4.86DX2. Boot sequence complete. All peripherals nominal. Welcome, Alex. Current time: 23:07. Standard OS log.",
				"father": null
			},
			"dk_invite_encrypted.log": { # Riferimento a Storia ID "1.3"
				"type": "log",
				"delete": true,
				"content": "SUBJECT: Your Entry Ticket (Encrypted)\n\nBODY: Vabgk1930XJTMB67$qpznvMNS75%trlszPQWI82+ubdgr...\nDECRYPTION KEY HINT: My initials, year of first major hack.\nCONTENT (DECRYPTED): IP: 192.168.34.76, PORT: 23331, PASS: prometeus. Welcome to the Echo Chamber. - DK. (This should be deleted.)",
				"father": null
			},
			"my_secret_projects_folder": {
				"type": "folder",
				"father": null,
				"children": ["project_alpha_notes.log", "backup_12_details.log", "utils_folder"]
			},
			"project_alpha_notes.log": { # Riferimento a Storia ID "0.0.2"
				"type": "log",
				"delete": true,
				"content": "PROGETTO_ALFA - Sistema di routing distribuito. Rifiutato da MicroTech ('troppo sperimentale'). Potenziale rivoluzionario. Appunti su sviluppi futuri e possibili implementazioni per reti anonime. Mantenere segreto.",
				"father": "my_secret_projects_folder"
			},
			"backup_12_details.log": { # Riferimento a Storia ID "0.0.1"
				"type": "log",
				"delete": true,
				"content": "BACKUP_12 - Algoritmo di cifratura avanzata. Chiave variabile basata su sequenze matematiche non lineari. Unica copia. Non divulgare. Potrebbe essere utile per comunicazioni sicure nell'Echo Chamber.",
				"father": "my_secret_projects_folder"
			},
			"utils_folder": {
				"type": "folder",
				"father": "my_secret_projects_folder",
				"children": ["camouflage_script_v1.sh"]
			},
			"camouflage_script_v1.sh": {
				"type": "script",
				"father": "utils_folder"
			},
			"bbs_public_logs_folder": {
				"type": "folder",
				"father": null,
				"children": ["digital_underground_chat_generic.log"]
			},
			"digital_underground_chat_generic.log": { # Riferimento a Storia ID "1.2.1"
				"type": "log",
				"delete": false,
				"content": "<BYTEBANDIT> overclocked cpu, kernel panic\n<BLASING> check heatsink?\n<DATANINJA> fbi raid in pittsburgh?\nStandard BBS chatter. Nothing compromising here.",
				"father": "bbs_public_logs_folder"
			}
		}
	),

	# Livello Scenario 1: "Caccia a Phoenix (Phantom)"
	# Obiettivo: Raccogliere prove contro Phantom (alias Phoenix) per aiutare DestinyComet.
	# Contesto: Alex sta collaborando attivamente con DC.
	LG_Level_class.new(
		240, # game time (secondi)
		45,  # scan_timer (secondi)
		{ # file_system
			"dc_briefing.log": { # Messaggio da DestinyComet
				"type": "log",
				"delete": false,
				"content": "From: DESTINYCOMET\nTo: £\nSubject: Operation Phoenix Takedown - Phase 1\n\n£, we need concrete evidence linking PHANTOM to Black Nexus and his alias 'Phoenix'. Search his known directories and any shared Echo Chamber resources he had access to. Look for access logs, code snippets, financial trails, or any mention of his real identity. Gather everything suspicious. Time is critical. -DC",
				"father": null
			},
			"phantom_known_dirs_folder": {
				"type": "folder",
				"father": null,
				"children": ["repo_access_16_01.log", "bn_code_fragments_P-M.log", "financial_analysis_folder", "personal_notes_phantom_folder"]
			},
			"repo_access_16_01.log": { # Riferimento a Storia ID "11 P.S." e "11.2"
				"type": "log",
				"delete": true, # Raccogliere
				"content": "Repository Access Log - 16/01/1994:\n02:13 - User 'PHANTOM' - Download initiated: /core/network_arch/*\n02:15 - User 'PHANTOM' - Download initiated: /core/transaction_protocols/*\n04:45 - User 'PHANTOM' - Outbound encrypted data stream to IP 82.115.34.10 (BN_Staging_Server).\nThis is highly suspicious. Collect this.",
				"father": "phantom_known_dirs_folder"
			},
			"bn_code_fragments_P-M.log": { # Riferimento a Storia ID "16.2"
				"type": "log",
				"delete": true, # Raccogliere
				"content": "Black Nexus Code Snippets (Source: DC_Intel_Recovered_Cache):\n// Routing optimization - /*P-M*/\n// Transaction handler - /*P-M*/\n// Authentication module - /*P-M*/\nComment style '/*P-M*/' is PHANTOM's known signature. Strong indication of involvement. Collect.",
				"father": "phantom_known_dirs_folder"
			},
			"financial_analysis_folder": {
				"type": "folder",
				"father": "phantom_known_dirs_folder",
				"children": ["phantom_crypto_trace.log"]
			},
			"phantom_crypto_trace.log": {
				"type": "log",
				"delete": true, # Raccogliere
				"content": "Crypto Wallet Analysis (Suspected PHANTOM):\nWallet ID: 1PhAnToMXbkNetXfr33dom... (linked to PHANTOM's EC payouts)\n- Multiple large transfers from known shell corporations (Cayman Islands, Panama) post-BN launch.\n- Pattern consistent with funding a new large-scale dark market operation and receiving operator share. Collect this.",
				"father": "financial_analysis_folder"
			},
			"personal_notes_phantom_folder": {
				"type": "folder",
				"father": "phantom_known_dirs_folder",
				"children": ["phantom_alias_research_notes.log", "evasion_script_dev.sh"]
			},
			"phantom_alias_research_notes.log": {
				"type": "log",
				"delete": true, # Raccogliere
				"content": "Personal Research Notes (File: phoenix_origins.txt - recovered from PHANTOM's temp):\n- Alias 'Phoenix' used in early BBS discussions (circa '90-'91) by user with IP trace similar to PHANTOM's known proxies.\n- Topics: unrestricted markets, critique of 'ethical' limitations in digital commerce.\n- Possible real name lead from old forum registration (unverified): 'Martin P. H...' - Needs further investigation. Collect.",
				"father": "personal_notes_phantom_folder"
			},
			"evasion_script_dev.sh": {
				"type": "script",
				"father": "personal_notes_phantom_folder"
			},
			"echo_chamber_shared_folder": {
				"type": "folder",
				"father": null,
				"children": ["sb_daily_traffic_report.log", "ec_dev_general_chat.log"]
			},
			"sb_daily_traffic_report.log": {
				"type": "log",
				"delete": false,
				"content": "Shadow Bazaar Daily Traffic Report: Unique Visitors: 12,540. Transactions: 873. System Nominal. Standard operational log, not relevant to PHANTOM's activities.",
				"father": "echo_chamber_shared_folder"
			},
			"ec_dev_general_chat.log": {
				"type": "log",
				"delete": false,
				"content": "<CIPHER> Working on new encryption layer for SB v2. <TESLA_X> Hardware nodes stable. <£> Routing algorithm performing well. <PHANTOM> Looks good, guys. Keep it up. (Generic dev chat, pre-BN suspicion).",
				"father": "echo_chamber_shared_folder"
			}
		}
	),

	# Livello Scenario 2: "Fuga da Shadow Nexus"
	# Obiettivo: Cancellare tutte le tracce del coinvolgimento di Alex in Shadow Nexus.
	# Contesto: La polizia è vicina, Alex deve sparire digitalmente da Shadow Nexus (un progetto compromesso).
	LG_Level_class.new(
		210, # game time (secondi)
		40,  # scan_timer (secondi)
		{ # file_system
			"urgent_warning.log": {
				"type": "log",
				"delete": false,
				"content": "ALERT - IMMEDIATE ACTION REQUIRED:\nSystem intrusion detected on Shadow Nexus master server. IP trace leads to law enforcement. All personnel with admin access must sanitize their activity logs and personal files related to Project Nexus IMMEDIATELY. This is not a drill. Evacuate digital presence.",
				"father": null
			},
			"alex_nexus_dev_workstation_folder": {
				"type": "folder",
				"father": null,
				"children": ["nexus_core_commits_by_alex.log", "private_comms_nexus_team.log", "nexus_access_credentials_alex.log", "revenue_share_agreement_alex_nexus.log", "data_wipe_script.sh"]
			},
			"nexus_core_commits_by_alex.log": {
				"type": "log",
				"delete": true, # Cancellare
				"content": "Commit Log - Shadow Nexus Core Repository:\n- Commit #a3f4c1 by £ (Alex Chen) on 15/02/1994: 'Implemented core transaction module for Shadow Nexus. Bypassed ethical filters as per spec.'\n- Commit #b7d5e2 by £ (Alex Chen) on 18/02/1994: 'Added untraceable payment routing for specialized goods category.'\nCRITICAL - These logs directly link me to Nexus development. DELETE.",
				"father": "alex_nexus_dev_workstation_folder"
			},
			"private_comms_nexus_team.log": {
				"type": "log",
				"delete": true, # Cancellare
				"content": "Private Encrypted Chat Log - Alex Chen (£) & BN_Dev_Lead (Unknown):\n£: The payment routing for untraceable goods is complete and tested.\nBN_Dev_Lead: Excellent. Phoenix will be pleased. Ensure all backdoors are secure and your involvement is masked.\nThis conversation is damning. DELETE.",
				"father": "alex_nexus_dev_workstation_folder"
			},
			"nexus_access_credentials_alex.log": {
				"type": "log",
				"delete": true, # Cancellare
				"content": "Shadow Nexus Admin Access Credentials (For Alex Chen):\nUser: alex_c_override\nPass: N3xu$!sMyCreation77\nDev Server IP: 10.7.7.1 (internal)\nThese credentials must be wiped. DELETE.",
				"father": "alex_nexus_dev_workstation_folder"
			},
			"revenue_share_agreement_alex_nexus.log": {
				"type": "log",
				"delete": true, # Cancellare
				"content": "MEMORANDUM - CONFIDENTIAL\nSubject: Revenue Share Agreement - Shadow Nexus Project.\nParticipant: Alex Chen (alias £).\nShare: 15% net profit from 'specialized goods' category. Payments to Wallet: 1£AlExCoInShAdOw...\nThis links my finances to Nexus. DELETE.",
				"father": "alex_nexus_dev_workstation_folder"
			},
			"data_wipe_script.sh": {
				"type": "script",
				"father": "alex_nexus_dev_workstation_folder"
			},
			"shadow_nexus_public_data_folder": {
				"type": "folder",
				"father": null,
				"children": ["nexus_public_forum_archive.log", "nexus_api_docs_public.log"]
			},
			"nexus_public_forum_archive.log": {
				"type": "log",
				"delete": false,
				"content": "<UserX> Is Shadow Nexus safe? <UserY> Seems legit, bought some stuff. No issues. <AdminBot> Welcome to Shadow Nexus! Please read the rules. (Standard user discussion, not incriminating for me).",
				"father": "shadow_nexus_public_data_folder"
			},
			"nexus_api_docs_public.log": {
				"type": "log",
				"delete": false,
				"content": "Shadow Nexus API v1.0 - Public Documentation for Developers.\nDescribes public endpoints for listing items, searching, etc. Contains no sensitive internal data or my direct involvement.",
				"father": "shadow_nexus_public_data_folder"
			}
		}
	),

	# Livello Scenario 3: "Caccia a Phoenix (Phantom) - Round 2"
	# Obiettivo: Raccogliere ulteriori prove contro Phantom, magari più difficili da trovare.
	# Contesto: Alex e DC continuano la loro indagine, cercando la pistola fumante.
	LG_Level_class.new(
		260, # game time (secondi)
		40,  # scan_timer (secondi)
		{ # file_system
			"dc_update_phoenix_hunt.log": {
				"type": "log",
				"delete": false,
				"content": "From: DESTINYCOMET\nTo: £\nSubject: RE: Phoenix Takedown - Phase 2\n\n£, PHANTOM is covering his tracks well. We need something more direct. Check deeper server logs on BN if you can get access, look for encrypted communications he might have overlooked, or any direct financial links to 'Phoenix' operations. His real identity is still elusive. -DC",
				"father": null
			},
			"bn_deep_server_dive_folder": {
				"type": "folder",
				"father": null,
				"children": ["phantom_bn_server_access.log", "encrypted_comms_phantom_supplier.log", "recovered_phantom_personal_folder", "admin_utils_bn_folder"]
			},
			"phantom_bn_server_access.log": {
				"type": "log",
				"delete": true, # Raccogliere
				"content": "Black Nexus Server Access Log (IP: 82.115.34.10) - Filtered for 'phoenix_admin':\n- User 'phoenix_admin' login from known PHANTOM proxy chain (IP: 172.16.X.X -> ... -> 203.0.113.X). Time: 03:17 AM.\n- Activity: Code deployment for 'unrestricted_listings_module_v2'. File diff shows removal of all ethical safeguards. Collect.",
				"father": "bn_deep_server_dive_folder"
			},
			"encrypted_comms_phantom_supplier.log": {
				"type": "log",
				"delete": true, # Raccogliere
				"content": "Intercepted PGP Message (Partial Decryption - Key Fragment Found):\nTo: phoenix_admin@bn.onion\nFrom: arms_dealer_01@dark.net\nSubject: Shipment Confirmed - Project Chimera\nBody: ...package 'Alpha-7' (military-grade explosives) will be available on BN next week. Payment to wallet 1PhAnToMX... confirmed. This is solid. Collect.",
				"father": "bn_deep_server_dive_folder"
			},
			"recovered_phantom_personal_folder": {
				"type": "folder",
				"father": "bn_deep_server_dive_folder",
				"children": ["phantom_real_id_clue.log", "bn_financials_phoenix_share.log"]
			},
			"phantom_real_id_clue.log": {
				"type": "log",
				"delete": true, # Raccogliere
				"content": "Fragment from deleted personal file (drive_wipe_error_cache.tmp - PHANTOM's old handle 'MartyP'):\n'...insurance policy update for Martin P. Henderson. Beneficiary: Classified. Note to self: use different alias for next project, 'Phoenix' is too obvious after the '91 BBS posts on free markets...'\nThis could be his real name! Collect.",
				"father": "recovered_phantom_personal_folder"
			},
			"bn_financials_phoenix_share.log": {
				"type": "log",
				"delete": true, # Raccogliere
				"content": "Black Nexus - Internal Financial Report (Q1 1994 - Leaked by DC's source):\nProjected Revenue (Illegal Arms): $2.5M\nProjected Revenue (Data Brokerage): $1.8M\nOperator Share (Phoenix/PHANTOM): 40%\nThis shows motive and scale. Collect.",
				"father": "recovered_phantom_personal_folder"
			},
			"admin_utils_bn_folder": {
				"type": "folder",
				"father": "bn_deep_server_dive_folder",
				"children": ["bn_stealth_mode.sh"]
			},
			"bn_stealth_mode.sh": {
				"type": "script",
				"father": "admin_utils_bn_folder"
			},
			"shadow_bazaar_maintenance_logs_folder": {
				"type": "folder",
				"father": null,
				"children": ["sb_uptime_report_current.log", "ec_crypto_advancements_chat.log"]
			},
			"sb_uptime_report_current.log": {
				"type": "log",
				"delete": false,
				"content": "Shadow Bazaar Uptime: 99.98% last 30 days. All systems green. Routine SB log, not relevant.",
				"father": "shadow_bazaar_maintenance_logs_folder"
			},
			"ec_crypto_advancements_chat.log": {
				"type": "log",
				"delete": false,
				"content": "<NEUROMANCER> DCS v2 is more scalable and offers better privacy features. <VALIS> But what about transaction fees and network congestion? (Standard technical debate in Echo Chamber, unrelated to PHANTOM's BN activities).",
				"father": "shadow_bazaar_maintenance_logs_folder"
			}
		}
	),

	# Livello Scenario 4: "Pulizia Pre-Fuga (Shadow Bazaar Illegale)"
	# Obiettivo: Cancellare le tracce del coinvolgimento di Alex nell'introduzione di merce illegale in Shadow Bazaar, prima di un piano di fuga con DarkKnight.
	# Contesto: Alex ha "corrotto" Shadow Bazaar e ora deve coprire le sue tracce.
	LG_Level_class.new(
		300, # game time (secondi)
		30,  # scan_timer (secondi)
		{ # file_system
			"dk_final_instructions.log": {
				"type": "log",
				"delete": false,
				"content": "From: DARKKNIGHT\nTo: £\nSubject: Operation Sundown - Final Checklist\n\n£, the window for our exit is closing. Authorities are sniffing around SB due to 'unforeseen market diversification'. Before we activate Protocol Nebbia, ensure ALL your personal traces related to the 'grey market' additions are GONE. This includes comms, transaction overrides, code mods. No mistakes. Rendezvous at Zulu point, 0300. -DK",
				"father": null
			},
			"alex_sb_modifications_folder": {
				"type": "folder",
				"father": null,
				"children": ["sb_illegal_goods_mod_alex.log", "comms_alex_vendor_nightshade.log", "sb_transaction_override_alex.log", "dk_escape_plan_alex_notes.log", "secure_delete_utility.sh"]
			},
			"sb_illegal_goods_mod_alex.log": {
				"type": "log",
				"delete": true, # Cancellare
				"content": "Personal Log - Alex Chen (alias £) - File: sb_grey_market.devlog\n- Successfully modified Shadow Bazaar core v1.7 to allow listing of 'grey_market_pharmaceuticals' and 'exotic_software_tools' under obfuscated categories.\n- Bypassed DK's ethical filters using admin override. DK must NOT find out about these specific category mods before the 'plan' is in motion. DELETE THIS.",
				"father": "alex_sb_modifications_folder"
			},
			"comms_alex_vendor_nightshade.log": {
				"type": "log",
				"delete": true, # Cancellare
				"content": "Encrypted Communication Log - £ & Vendor 'NightshadeSupply':\n£: Your new 'specialty items' (unlicensed neuro-stimulants) are now listable on SB. Use Category ID: 'Rare_Collectibles_77B'. Discretion is paramount.\nNS: Understood. Payment for the backdoor access and listing privileges (5 BTC) sent to your designated wallet. This links me directly. DELETE.",
				"father": "alex_sb_modifications_folder"
			},
			"sb_transaction_override_alex.log": {
				"type": "log",
				"delete": true, # Cancellare
				"content": "Shadow Bazaar Transaction Override Log - Entry #4A3F8C:\n- Transaction ID: SBX7719F\n- Listed Item: 'Vintage Microprocessor (Collector's Edition)'\n- Actual Item (Override Note by £): Unlicensed Neuro-Stimulants Batch #003\n- Buyer: Wallet X (Anonymous), Seller: Wallet Y (linked to £'s private override account for commission)\nCRITICAL - This transaction log must be scrubbed. DELETE.",
				"father": "alex_sb_modifications_folder"
			},
			"dk_escape_plan_alex_notes.log": {
				"type": "log",
				"delete": true, # Cancellare (perché lega Alex al piano DOPO aver fatto cose illegali)
				"content": "DK's Escape Plan (Operation Nebbia) - My Personal Notes & Checklist:\nPhase 1: Asset liquidation (convert my illegal SB earnings to Monero first - Wallet ID: ...).\nPhase 2: Digital identity wipe (ensure all SB mod logs, comms with NightshadeSupply, and transaction overrides are GONE).\nPhase 3: Rendezvous Point Zulu with DK. DO NOT BE LATE. DK is counting on my clean exit. My involvement in the 'grey market' cannot be traced. DELETE.",
				"father": "alex_sb_modifications_folder"
			},
			"secure_delete_utility.sh": {
				"type": "script",
				"father": "alex_sb_modifications_folder"
			},
			"shadow_bazaar_public_relations_folder": {
				"type": "folder",
				"father": null,
				"children": ["sb_user_feedback_general.log", "dk_opsec_reminder_echo_chamber.log"]
			},
			"sb_user_feedback_general.log": {
				"type": "log",
				"delete": false,
				"content": "Shadow Bazaar User Feedback - General Channel:\n<User123> Love the new UI on Shadow Bazaar! So much cleaner.\n<User456> Wish there were more items in the 'Electronics' category.\n(General user feedback, not incriminating for my specific illegal activities).",
				"father": "shadow_bazaar_public_relations_folder"
			},
			"dk_opsec_reminder_echo_chamber.log": {
				"type": "log",
				"delete": false,
				"content": "MEMORANDUM From: DARKKNIGHT\nTo: Echo Chamber Core Team\nSubject: OPSEC Reminder\n\nTeam, a general reminder to maintain strict operational security in all communications and development activities. Loose lips sink ships. This is standard procedure. (Not directly related to my illegal merchandise or the escape plan).",
				"father": "shadow_bazaar_public_relations_folder"
			}
		}
	)
]




func get_level(levelNum: int) -> LG_Level_class:
	return levels[levelNum-1]