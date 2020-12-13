extends CanvasLayer

signal show_player
signal mouse_click


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func beginTutorial():
	get_tree().paused = true
	$Intro1.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$Intro1.hide()
	$Intro2.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$Intro2.hide()
	$Intro3.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$Intro3.hide()
	$Intro4.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$Intro4.hide()
	$Intro5.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$Intro5.hide()
	$Intro6.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$Intro6.hide()
	get_tree().paused = false
	
func endTutorial():
	get_tree().paused = true
	$end1.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$end1.hide()
	$end2.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$end2.hide()
	$end3.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_firstHit():
	get_tree().paused = true
	emit_signal("show_player")
	$hit1.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$hit1.hide()
	$hit2.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$hit2.hide()
	$hit3.show()
	#yield(get_tree().create_timer(5.0), "timeout")
	yield(self,"mouse_click")
	$hit3.hide()
	get_tree().paused = false

var saveDat = {
	"name": "",
	"level": 2,
	"coins": 0,
	"vol": 1.0
}

const FILE_NAME = "user://game-data.json"

func saveData():
	var file = File.new()
	file.open_encrypted_with_pass(FILE_NAME, File.WRITE, "14ReasonsWhy")
	file.store_string(to_json(saveDat))
	file.close()

func _on_submit_pressed():
	if $end3/TextEdit.text == "":
		saveDat["name"] = "PercyX"
	else:
		saveDat["name"] = $end3/TextEdit.text
	saveData()
	$end3.hide()
	get_tree().paused = false
	

func _input(event):
	if(Input.is_mouse_button_pressed(BUTTON_LEFT) and event.is_pressed() and not event.is_echo()):
		emit_signal("mouse_click")

func _on_TextEdit_text_changed():
	var temp = $end3/TextEdit.text
	var maxTempSize = 10
	if temp.length() > maxTempSize:
		$end3/TextEdit.text = temp.substr(0, maxTempSize)
