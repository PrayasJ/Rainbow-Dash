extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var id

func getWidth():
	return $AnimatedSprite.texture.get_size().x*$AnimatedSprite.scale.x

var colors = [Color(1,0,0),Color(0,1,0),Color(0,0,1),Color(1,1,0),Color(1,0,1),Color(0,1,1),Color(1,1,1)]
# Called when the node enters the scene tree for the first time.
func set_scale(val):
	$AnimatedSprite.scale.x = val * $AnimatedSprite.scale.x
	$CollisionShape2D.scale.y = val * $CollisionShape2D.scale.y
	$VisibilityNotifier2D.scale.y = val * $VisibilityNotifier2D.scale.y
# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(randi()%5 + 1)

func getColor():
	return colors[id]

func setCol(col):
	id = col
	$AnimatedSprite.modulate = colors[id]

func get_height():
	return id*0.15 + 0.15

func getID():
	return id
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
