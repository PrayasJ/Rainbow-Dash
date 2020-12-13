extends CanvasLayer

signal start_game
signal end
signal show_player

func _ready():
	$height.position.x = get_viewport().size.x/2
	pause_mode = Node.PAUSE_MODE_PROCESS
	loadData()

const FILE_NAME = "user://game-data.json"

var saveDat = {
	"name": "",
	"level": 1,
	"coins": 0,
	"vol": 1.0
}

func saveData():
	var file = File.new()
	file.open_encrypted_with_pass(FILE_NAME, File.WRITE, "14ReasonsWhy")
	file.store_string(to_json(saveDat))
	file.close()

func loadData():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open_encrypted_with_pass(FILE_NAME, File.READ, "14ReasonsWhy")
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			saveDat = data
			if saveDat["name"] != "":
				$coin/value.bbcode_enabled = true
				$coin/value.bbcode_text = "[tornado radius=5 freq=2][wave amp=150 freq=4][rainbow freq=0.2 sat=10 val=20] x "+str(saveDat["coins"])+"[/rainbow][/wave][/tornado]"
				$Name.show()
				$Name.bbcode_enabled = true
				$Name.bbcode_text = "[center][tornado radius=5 freq=2]Welcome\n"+saveDat["name"]+"[/tornado][/center]"
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
		$coin/value.bbcode_enabled = true
		$coin/value.bbcode_text = "[tornado radius=5 freq=2][wave amp=150 freq=4][rainbow freq=0.2 sat=10 val=20] x 0[/rainbow][/wave][/tornado]"
		

func show_message(text):
	$Message.bbcode_text = "[center]"+text+"[/center]"
	$Message.show()
	$MessageTimer.start()

func show_info():
	$ScoreLabel.show()
	$LevelLabel.show()
	$height.show()

func show_game_over(lives):
	$GameOverPop.show()
	get_tree().paused = true

func update_score(score):
	$ScoreLabel.text = str(score*10)+"%"

func set_level(level):
	$LevelLabel.text = "Level " + str(level)

func _on_StartButton_pressed():
	$StartButton.hide()
	$Name.hide()
	$Settings.hide()
	$Exit.hide()
	$aboutUs.hide()
	#$Pause.show()
	$coin.hide()
	emit_signal("start_game")
	#$ColorTimer.stop()

func set_height_bar(val):
	$height.scale.x = val

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_Exit_pressed():
	get_tree().quit()

func _on_Settings_pressed():
	_on_closeAboutUs_pressed()
	_on_closeSettings_pressed()
	$SettingsPop.show()
	$SettingsPop/test.play()
	get_tree().paused = true


func _on_aboutUs_pressed():
	
	$AboutUsPop.show()
	$aboutUs.hide()
	get_tree().paused = true


func _on_Pause_pressed():
	$PauseMenu.show()
	$Pause.hide()
	get_tree().paused = true


func _on_Resume_pressed():
	$PauseMenu.hide()
	$Pause.show()
	get_tree().paused = false


func _on_closeAboutUs_pressed():
	$AboutUsPop.hide()
	$aboutUs.show()
	get_tree().paused = false

func _on_closeSettings_pressed():
	$SettingsPop.hide()
	$SettingsPop/test.stop()
	get_tree().paused = false

func _on_ResumeGame_pressed():
	$Pause.show()
	emit_signal("show_player")
	$resumeTimer.start()
	$resumeTime.show()
	$GameOverPop.hide()
	get_tree().paused = true

func _on_RestartGame_pressed():
	$Pause.show()
	emit_signal("end")
	get_tree().paused = false
	$GameOverPop.hide()
	emit_signal("start_game")


func _on_ExitToMenu_pressed():
	emit_signal("end")
	get_tree().paused = true
	$GameOverPop.hide()
	$Pause.hide()
	show_message("Game\nOver")
	$height.hide()
	loadData()
	yield($MessageTimer, "timeout")
	$Message.bbcode_text = "[center][tornado radius=5 freq=2][rainbow freq=0.2 sat=10 val=20]Iris\n\nZone[/rainbow][/tornado][/center]"
	$Message.show()
	#$ColorTimer.start()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().paused = false
	$StartButton.show()
	$Name.show()
	$Settings.show()
	$aboutUs.show()
	$coin.show()
	$Exit.show()


func _on_resumeTimer_timeout():
	$resumeTime.hide()
	get_tree().paused = false

func _process(delta):
	if(!$resumeTimer.is_stopped()):
		$resumeTime.text = str(int(ceil($resumeTimer.time_left)))
		$resumeTime.get("custom_fonts/font").set_size(120 - 40*($resumeTimer.time_left - floor($resumeTimer.time_left)));


func _on_RestartG_pressed():
	$PauseMenu.hide()
	$Pause.show()
	#emit_signal("end")
	get_tree().paused = false
	emit_signal("start_game")


func _on_ExitToM_pressed():
	$PauseMenu.hide()
	emit_signal("end")
	get_tree().paused = false
	$GameOverPop.hide()
	$Pause.hide()
	loadData()
	show_message("Game\nOver")
	$height.hide()
	yield($MessageTimer, "timeout")
	$Message.bbcode_text = "[center][tornado radius=5 freq=2][rainbow freq=0.2 sat=10 val=20]Chrome\n\nZone[/rainbow][/tornado][/center]"
	$Message.show()
	#$ColorTimer.start()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$Name.show()
	$Settings.show()
	$aboutUs.show()
	$coin.show()
	$Exit.show()


func _on_vol_dec_pressed():
	if saveDat['vol'] >= 0.05:
		saveDat['vol'] -= 0.05 
	else:
		saveDat['vol'] = 0.0
	saveData()
	$SettingsPop/test.volume_db = linear2db(saveDat['vol'])
	$SettingsPop/vol_val.text = str(saveDat['vol']*100)+"%"

func _on_vol_inc_pressed():
	if saveDat['vol'] <= 0.95:
		saveDat['vol'] += 0.05 
	else:
		saveDat['vol'] = 1.0
	saveData()
	$SettingsPop/test.volume_db = linear2db(saveDat['vol'])
	$SettingsPop/vol_val.text = str(saveDat['vol']*100)+"%"
