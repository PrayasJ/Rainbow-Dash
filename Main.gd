extends Node

export (PackedScene) var Mob
var score
var level = 1
var lives
func _init():
	loadData()
	level = saveDat["level"]

func _ready():
	randomize()
	$CanvasModulate.hide()
	$MobTimer.wait_time = pow(level,-0.15)
	#$StartPosition.position.y = OS.get_real_window_size().y*0.7

func game_over():
	$HUD/Pause.hide()
	$HUD/GameOverPop.show()
	get_tree().paused = true
	loadData()
	saveDat["coins"] = saveDat["coins"] + $Player.getCoins()
	$Player.coinReset()
	saveData()


func next_level():
	loadData()
	$Player/Light2D.color = Color(1,1,1)
	$HUD/GameOverPop/ResumeGame.show()
	score = 0
	level = level + 1
	lives = 3
	saveDat["level"] = level
	saveDat["coins"] = saveDat["coins"] + $Player.getCoins()
	$Player.coinReset()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$LevelTimer.stop()
	$Player.start($StartPosition.position, false)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.set_level(level)
	$HUD.show_message("New\nLevel\nBegins!")
	#$Music.play()
	get_tree().call_group("mobs", "queue_free")
	saveData()

func new_game():
	loadData()
	$Player/Light2D.color = Color(1,1,1)
	if saveDat["name"] =="":
		$HUD/GameOverPop/ResumeGame.show()
		$HUD/Pause.hide()
		score = 0
		lives = 3
		$Player.start($StartPosition.position, true)
		$StartTimer.start()
		$HUD.update_score(score)
		$HUD.set_level(level)
		$HUD.show_info()
		$HUD.show_message("")
		$TutorialOverLay.beginTutorial()
		#var audio_file = "res://dodge_assets/music/bgm"+str(randi()%9 + 1)+".wav"
		#print(audio_file)
		#if File.new().file_exists(audio_file+".import"):
		#	var sfx = ResourceLoader.load(audio_file)
		#	$Music.stream = sfx
		
		#$Music.volume_db = linear2db(saveDat['vol'])
		$Music.play()
	else:
		$HUD/GameOverPop/ResumeGame.show()
		score = 0
		lives = 3
		$Player.start($StartPosition.position, false)
		get_tree().call_group("mobs", "queue_free")
		$StartTimer.start()
		$HUD.update_score(score)
		$HUD.set_level(level)
		$HUD.show_info()
		$HUD.show_message("Get\nReady")
		#var audio_file = "res://dodge_assets/music/bgm"+str(randi()%9 + 1)+".wav"
		#print(audio_file)
		#if File.new().file_exists(audio_file+".import"):
		#	var sfx = ResourceLoader.load(audio_file)
		#	$Music.stream = sfx
		#$Music.volume_db = linear2db(saveDat['vol'])
		$Music.play()


func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.setDir(direction)
	mob.position = $MobPath/MobSpawnLocation.position
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	


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
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")

func _on_ScoreTimer_timeout():
	score += 0.1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$LevelTimer.start()
	$CanvasModulate.show()
	$HUD/Pause.show()

func _on_LevelTimer_timeout():
	loadData()
	if saveDat["name"] == "":
		$TutorialOverLay.endTutorial()
		$HUD/Name.show()
		$HUD/Pause.show()
	next_level()

func _process(delta):
	$HUD.set_height_bar($Player.dispHeightGap()*4)


func _on_HUD_end():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$LevelTimer.stop()
	$HUD.show_game_over(lives)
	get_tree().call_group("mobs", "queue_free")
	$Player.hide()
	$HUD/LevelLabel.hide()
	$HUD/ScoreLabel.hide()
	$CanvasModulate.hide()


func _on_HUD_show_player():
	lives = lives - 1
	if lives == 1:
		#$DeathSound.play()
		$HUD/GameOverPop/ResumeGame.hide()
	else:
		$HUD/GameOverPop/ResumeGame.show()


func _on_TutorialOverLay_show_player():
	lives = lives - 1


func _on_Music_finished():
	if $Player.visible == true:
		#var audio_file = "res://dodge_assets/music/bgm"+str(randi()%9 + 1)+".wav"
		#print(audio_file)
		#if File.new().file_exists(audio_file+".import"):
		#	var sfx = ResourceLoader.load(audio_file)
		#	$Music.stream = sfx
		#$Music.volume_db = linear2db(saveDat['vol'])
		$Music.play()
