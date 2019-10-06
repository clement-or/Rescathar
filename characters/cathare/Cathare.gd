extends "res://characters/Character.gd"

export(NodePath) var navigation_map
export(NodePath) var default_target
onready var female = preload("res://characters/cathare/female.png")

var path
var target


func _ready():
  randomize()
  if bool(randi()%2):
    $Sprite.texture = female
    print("female")
  if navigation_map:
    navigation_map = get_node(navigation_map)

func _process(delta):
  move(delta)
  update()

func move(delta):
  if path:
  	target_position = path[0]

  	direction = (target_position - global_position).normalized()
  	global_position += direction * speed * delta

  	if global_position.distance_to(target_position) < 1:
      global_position = target_position
      # Remove first path point
      path.remove(0)
      if path.size() == 0:
      	path = null

func is_type(type): return type == "Cathare"
func get_type(): return "Cathare"
