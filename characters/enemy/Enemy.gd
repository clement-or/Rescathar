extends "res://characters/Character.gd"

signal cathare_list_requested

export(NodePath) var navigation_map
export(NodePath) var player
export(NodePath) var prison
export var sight_distance = 10

var path
var target
var cathare_list
var holds_cathare = false
var is_following_player = false


func _ready():
  assert(navigation_map)
  assert(player)
  assert(prison)
  if navigation_map:
    navigation_map = get_node(navigation_map)
    tile_size = navigation_map.cell_size.x
    sight_distance = tile_size*sight_distance
  if player:
    player = get_node(player)
  if prison:
    prison = get_node(prison)


func _process(delta):
  move(delta)

func move_to(position : Vector2):
  path = navigation_map.find_path(global_position, position)
  path.remove(0)


func start_following(t : Node):
  if target:
    stop_following()
  target = t
  $FollowTimer.start()

func stop_following():
  $FollowTimer.stop()
  target = null

func _on_FollowTimer_timeout():
  path = navigation_map.find_path(global_position, target.global_position)
  main()


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

##
# Actions
##

func main():
  var rnd
  if is_following_player:
    if player_is_hidden() || !player_has_cathares():
      is_following_player = false
    return

  if !holds_cathare:
    if player_in_range():
      rnd = randi()%3
    else:
      rnd = randi()%2
      rnd = 1
    match rnd:
      0:
        wander()
      1:
        follow_new_cathare()
      2:
        follow_player()
        is_following_player = true
  else:
    go_to_prison()


func follow_new_cathare():
  get_cathare_list()
  randomize()
  var rnd = randi()%(cathare_list.size()-1)
  if target:
    stop_following()
  start_following(cathare_list[rnd])

func follow_player():
  start_following(player)

func go_to_prison():
  if prison:
    stop_following()
    move_to(prison.global_position)

func wander():
  yield(get_tree().create_timer(1.0), )


##
# Preconds
##
func player_is_hidden():
  if player:
    return player.is_hidden

func player_in_range():
  if player:
    if !player_is_hidden() && global_position.distance_to(player.global_position) <= sight_distance:
      return true

func player_has_cathares():
  if player:
    if player.cathare_inventory > 0:
      return true

##
# Signals funcs
##

func get_cathare_list():
  emit_signal("cathare_list_requested", self)

func _on_Enemy_area_entered(area):
  if area.has_method("is_type"):
    if area.is_type("Enemy"):
      return
    if area.is_type("Cathare") && !is_following_player && !holds_cathare:
      stop_following()
      area.queue_free()
      holds_cathare = true
      main()
  if area.is_in_group("prison") && holds_cathare:
    holds_cathare = false
    main()
  if area.get_name() == "Player":
    if area.cathare_inventory > 0:
      var rnd = randi()%4+1
      area.cathare_inventory -= rnd
    else:
      print("Player is ded")


func _on_IATimer_timeout():
  main()

func is_type(type):
  return type == "Enemy"


func _on_Level_is_ready():
	pass
