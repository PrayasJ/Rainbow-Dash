extends Area2D

signal hit
signal firstHit

export var speed = 400
var screen_size
var height
var height_vel = 0
var JUMP_VELOCITY = 7.0
var g = 15
var jumptime
var height_gap = 0
var gbody = null
var jumping = false
var hitFlag = false
var coins

func _ready():
	screen_size = get_viewport_rect().size
	height = 0
	coins = 0
	hide()
	position.y = screen_size.y*0.9
	$AnimatedSprite.play()

func jump_init(delta):
	height = 0
	height_vel = JUMP_VELOCITY
	jumptime = 0
	#$CollisionShape2D.disabled = true
	z_index = 1
	jumping = true
	$JumpTimer.start()

func jump_end():
	#$CollisionShape2D.disabled = false
	height_vel = 0
	height = 0
	jumptime = 0
	$Light2D.scale.x = 0.75
	$Light2D.scale.x = 0.75
	$AnimatedSprite.scale.x = 0.05
	$AnimatedSprite.scale.y = 0.05

func jump(delta):
	jumptime = jumptime + delta
	height = height + height_vel*delta - delta*g*jumptime -g*delta*delta/2
	$AnimatedSprite.scale.x = 0.05 + 0.2*g*height/(JUMP_VELOCITY*JUMP_VELOCITY)
	$AnimatedSprite.scale.y = 0.05 + 0.2*g*height/(JUMP_VELOCITY*JUMP_VELOCITY)
	$Light2D.scale.x = 0.75 - 0.8*g*height/(JUMP_VELOCITY*JUMP_VELOCITY)
	$Light2D.scale.y = 0.75 - 0.8*g*height/(JUMP_VELOCITY*JUMP_VELOCITY)
	if height <= 0:
		jumping = false 

func get_height():
	return height

func _process(delta):
	var mouseRelPos = get_viewport().get_mouse_position().x - position.x
	var velocity = Vector2()  # The player's movement vector.
	if (Input.is_action_pressed("ui_right") or mouseRelPos > 10):
		velocity.x += 1
	if (Input.is_action_pressed("ui_left") or mouseRelPos < -10):
		velocity.x -= 1
	if (Input.is_action_just_pressed("jump") or Input.is_mouse_button_pressed(BUTTON_LEFT)) and jumping == false and $JumpTimer.is_stopped() == true:
		jump_init(delta)
	if (Input.is_action_pressed("jump") or Input.is_mouse_button_pressed(BUTTON_LEFT)) and jumping == true:
		pass
	else:
		height_vel = JUMP_VELOCITY/2
	if jumping == true:
		jump(delta)
	else:
		jump_end()
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	if gbody == null:
		height_gap = height
	else:
		height_gap = height - gbody.get_height()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_Player_body_entered(body):
	gbody = body
	print("Height : "+str(height)+" Wall Height: "+str(body.get_height()))
	if body.get_height() > height:
		if hitFlag == false:
			hitFlag = true
			hide()  # Player disappears after being hit.
			if isTutorial == true:
				emit_signal("firstHit")
				isTutorial = false
			else:
				emit_signal("hit")
			#$CollisionShape2D.set_deferred("disabled", true)

func dispHeightGap():
	return height_gap

var isTutorial

func start(pos, tut):
	isTutorial = tut
	position = pos
	show()


func _on_Player_body_exited(body):
	gbody = null
	hitFlag = false
	coins = coins + 1 + body.getID()
	print(coins)
	$Light2D.color = body.getColor()
	$Light2D.color.a = 0.5

func _on_HUD_show_player():
	show()

func getCoins():
	return coins

func coinReset():
	coins = 0

func _on_TutorialOverLay_show_player():
	show()
