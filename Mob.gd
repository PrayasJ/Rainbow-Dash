extends Sprite

export (PackedScene) var WallPiece

var id
var wallCount
var direction

func setDir(dir):
	direction = dir

var wallCol = []
var wallSize = []
func _ready():
	scale.x = scale.x*0.5
	wallCount = randi()%3 + 1
	var total = 0
	for i in range(wallCount):
		wallCol.append(randi()%7)
		wallSize.append(randi()%5)
		total = total + wallSize[i]
	var wall
	var pos = randi()%int(get_viewport().size.x)
	var vel = randi()%50 - 25
	for i in range(wallCount):
		wall = WallPiece.instance()
		for w in $Wall.get_children():
			wall.add_collision_exception_with(w)
		wall.position.x = pos
		wall.setCol(wallCol[i])
		pos = pos + wall.getWidth()*1.4
		wall.scale.x = wallSize[i]/(total+1)
		#wall.position.x = wall.position
		wall.linear_velocity = Vector2(250, vel)
		wall.linear_velocity = wall.linear_velocity.rotated(direction)
		$Wall.add_child(wall)
		
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

