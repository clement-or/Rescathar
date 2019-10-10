extends "res://characters/Character.gd"

onready var anim = $Sprite/Anim

export(NodePath) var navigation_map
export(NodePath) var prison
export(NodePath) var player
export(NodePath) var cathares_node

export var sight_distance = 5*64

var cathare_list
var target
var path

var holds_cathare = false

##
# Main funcs
##
func _ready():
	assert(navigation_map)
	assert(prison)
	assert(player)
	assert(cathares_node)
	navigation_map = get_node(navigation_map)
	prison = get_node(prison)
	player = get_node(player)
	cathare_list = get_node(cathares_node).get_children()
	
	yield(navigation_map, "ready")
	select_target()

func _process(delta):
	update_anim()

func move(delta):
	if !path:
		return
	target_position = path[0]
	direction = (target_position - global_position).normalized()
	global_position += direction * speed * delta

	if global_position.distance_to(target_position) <= 5:
		global_position = target_position
		
		# Remove first path point
		path.remove(0)
		if path.size() == 0:
			path = null
			select_target()

func select_target():
	if holds_cathare:
		return
	if player_in_range():
		start_following(player)
	else:
		randomize()
		if bool(randi()%2):
			follow_new_cathare()
		elif !path:
			wander()



##
# Follow methods
##
func start_following(t):
	stop_following()
	target = t
	$FollowTimer.start()

func stop_following():
	if target:
		$FollowTimer.stop()
		target = null

func follow_new_cathare():
	randomize()
	var rnd = 0
	if cathare_list.size() > 1:
		rnd = randi()%(cathare_list.size()-1)
		
	if cathare_list.size() > 0:
		start_following(cathare_list[rnd])
	elif !path:
		wander()

func recalculate_path():
	if target && target.is_inside_tree():
		path = navigation_map.find_path(global_position, target.global_position)
		select_target()
	get_cathare_list()

func wander():
	randomize()
	path = navigation_map.generate_random_path(global_position)

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
# Other funcs
##
func _on_Enemy_area_entered(area):
	if area.has_method("is_type"):
		if area.is_type("Cathare") && !holds_cathare:
			stop_following()
			area.queue_free()
			holds_cathare = true
			start_following(prison)
	if area.is_in_group("prison") && holds_cathare:
		holds_cathare = false
		stop_following()
		select_target()
	if area.get_name() == "Player":
		if player_has_cathares():
			var rnd = randi()%4+1
			area.cathare_inventory -= rnd
		else:
			print("Player is ded")

func get_cathare_list():
	cathare_list = get_node(cathares_node).get_children()

func update_anim():
	if direction == Vector2(1,0):
		$Sprite/Anim.play("walk_right")
	if direction == Vector2(-1, 0):
		$Sprite/Anim.play("walk_left")
	if direction == Vector2(0, -1):
		$Sprite/Anim.play("walk_top")
	if direction == Vector2(0, 1):
		$Sprite/Anim.play("walk_bottom")