extends "res://characters/Character.gd"

export(NodePath) var navigation_map
export(NodePath) var test_target

var path
var target
var is_following = true


func _ready():
  if navigation_map:
    navigation_map = get_node(navigation_map)
  start_following(get_node(test_target))


func _process(delta):
  move(delta)
  update()

func move_to(position : Vector2):
  path = navigation_map.find_path(global_position, position)
  path.remove(0)

func start_following(t : Node):
  if target:
    stop_following()
  $FollowTimer.start()
  target = t

func stop_following():
  $FollowTimer.stop()
  target = null

func _on_FollowTimer_timeout():
  path = navigation_map.find_path(global_position, target.global_position)

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

func _draw():
  if path:
    pass
