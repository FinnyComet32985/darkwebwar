extends Control

var username := ""
var cursor:bool
var loading_lable := ""

var command_dir := [
	"D", "I", "R"
]
var command_cd := [
	"C", "D", " ", "G", "I", "O", "C", "H", "I"
]
var command_dww := [
	"D", "A", "R", "K", "W", "E", "B", "W", "A", "R", ".", "E", "X", "E"
]

func _ready():
	
	await start_intro()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func get_loading_lable(path: String) -> String:
	if path == "": 
		return "C>"
	else: 
		return "C:\\"+path+">"
	
func start_intro():
	#blinking _
	for i in 5:
		cursor = !cursor
		await get_tree().create_timer(0.3).timeout
		if cursor == false:
			
			$Panel/Loading.text=get_loading_lable("")
		else: 
			$Panel/Loading.text=get_loading_lable("")+"_"
	
	var text
	
	
	#command dir
	for i in range(len(command_dir)):
		text = get_loading_lable("")
		for j in range(i+1):
			text += command_dir[j]
		await get_tree().create_timer(0.2).timeout
		$Panel/Loading.text=text+"_"
	await get_tree().create_timer(0.3).timeout
	$Panel/Loading.text = get_loading_lable("")+"".join(command_dir)+"\nIl volume nell'unità C è RE-DOS_4\nIl numero di serie del volume è 5164-7B1A\nDirectory di C:\\\n    APP        <DIR>       01-01-93  12:00a\n    DATI       <DIR>       01-01-93  12:05a\n    DOC        <DIR>       01-05-93   9:30a\n    GIOCHI     <DIR>       02-10-93   3:15p\n    SYSTEM     <DIR>       03-01-93  11:45a\n    UTILS      <DIR>       03-15-93   4:00p\n       6 File(s)        12345 bytes\n       6 Dir(s)      12345678 bytes free\n"+get_loading_lable("")
	
	# blinking _
	text = $Panel/Loading.text
	for i in range(4):
		cursor = !cursor
		await get_tree().create_timer(0.3).timeout
		if cursor == false:
			$Panel/Loading.text=text
		else: 
			$Panel/Loading.text=text+"_"
	
	# command cd Download
	var tmp = text
	for i in range(len(command_cd)):
		text = tmp
		for j in range(i+1):
			text += command_cd[j]
		await get_tree().create_timer(0.2).timeout
		$Panel/Loading.text=text+"_"
	await get_tree().create_timer(0.3).timeout
	$Panel/Loading.text= text+"\n"+get_loading_lable("GIOCHI")
	tmp = $Panel/Loading.text

	# blinking _
	text = $Panel/Loading.text
	for i in range(4):
		cursor = !cursor
		await get_tree().create_timer(0.3).timeout
		if cursor == false:
			$Panel/Loading.text=text
		else: 
			$Panel/Loading.text=text+"_"

	# command ls
	for i in range(len(command_dir)):
		text = tmp
		for j in range(i+1):
			text += command_dir[j]
		await get_tree().create_timer(0.2).timeout
		$Panel/Loading.text=text+"_"
	await get_tree().create_timer(0.3).timeout
	
	$Panel/Loading.text = text+"\n    DOOM      <DIR>           04-20-25   8:00p\n    DARKWEBWAR EXE     123456 04-22-25   9:15a\n       2 File(s)        123456 bytes\n       1 Dir(s)   87654321 bytes free\n"+get_loading_lable("GIOCHI")
	tmp = $Panel/Loading.text
	
	# blinking _
	text = $Panel/Loading.text
	for i in range(4):
		cursor = !cursor
		await get_tree().create_timer(0.3).timeout
		if cursor == false:
			$Panel/Loading.text=text
		else: 
			$Panel/Loading.text=text+"_"
	
	# command DarkWebWar
	for i in range(len(command_dww)):
		text = tmp
		for j in range(i+1):
			text += command_dww[j]
		await get_tree().create_timer(0.3).timeout
		$Panel/Loading.text=text+"_"
	await get_tree().create_timer(0.5).timeout
	
	$Panel/Loading.queue_free()
