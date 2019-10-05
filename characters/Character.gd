extends Area2D

var moves = {'right': Vector2(1, 0),
             'left': Vector2(-1, 0),
             'up': Vector2(0, -1),
             'down': Vector2(0, 1)}

var raycasts = {'right': $Raycasts/Right,
                'left': $Raycasts/Left,
                'up': $Raycasts/Up,
                'down': $Raycasts/Down}

export(NodePath) var tilemap
export(int) var speed = 10

var direction = 'right'
var can_move = true
var tile_size = 64


func _ready():
	if tilemap:
		tilemap = get_node(tilemap)
		tile_size = tilemap.cell_size

func move(dir):
	if raycasts[direction].is_colliding():
		bump()
		return
	direction = dir
	can_move = false
	# $AnimationPlayer.play(dir)
	$Tween.interpolate_property(self, "position", position,
									position + moves[position] * tile_size, 0.8,
									Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	return true

func bump():
	pass