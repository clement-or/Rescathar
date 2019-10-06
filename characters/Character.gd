extends Area2D

# Accessors to the nodes
onready var Raycast = $Raycast
onready var Anim = $Sprite/Anim

# Exports
export(NodePath) var tilemap
export(int) var speed = 256

var tile_size = 64

# Movement variables
var last_position = Vector2()
var target_position = Vector2()
var direction = Vector2()

func _ready():
  # Init tilemap
  if tilemap:
  	tilemap = get_node(tilemap)
  	tile_size = tilemap.cell_size.x

  # Init player pos
  global_position = global_position.snapped(Vector2(tile_size+0.5*tile_size, tile_size+0.5*tile_size))
  last_position = global_position
  target_position = global_position

func _process(delta):
  move(delta)

func move(delta):
  # Go in Idle state
  if global_position == target_position:
    get_movedir()
    last_position = global_position
    target_position += direction * tile_size

  # Check collisions
  if Raycast.is_colliding():
    bump()
  else:
    # Move
    global_position += direction*speed*delta

    # If we've gone too far, snap to grid
    if global_position.distance_to(last_position) >= tile_size:
      global_position = target_position

func bump():
  # Reset pos
  global_position = last_position
  target_position = last_position
# Ce code ne marche pas
"""
  if direction == Vector2(1, 0):
    Anim.play("bump_right")
  if direction == Vector2(0, 1):
    Anim.play("bump_down")
  if direction == Vector2(-1, 0):
    Anim.play("bump_left")
  if direction == Vector2(0, -1):
    Anim.play("bump_up")
"""

func get_movedir():
  if direction != Vector2.ZERO:
    Raycast.cast_to = direction * tile_size / 2
    update()

func _draw():
  var pos = Raycast.cast_to
  draw_circle(pos, 5, Color(1,0,0))
