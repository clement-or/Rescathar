extends TileMap

onready var astar_node = AStar.new()
export(Vector2) var map_size = Vector2(100, 100)

var path_start_position = Vector2() setget _set_path_start_position
var path_end_position = Vector2() setget _set_path_end_position

var _point_path = []

const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color('#fff')

onready var obstacles = get_used_cells_by_id(2)
onready var _half_cell_size = cell_size / 2

func _ready():
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)

func _process(delta):
	update()


# Loops through all cells within the map's bounds and
# adds all points to the astar_node, except the obstacles
func astar_add_walkable_cells(obstacles = []):
	var points_array = []
	for y in range(map_size.y):
		for x in range(map_size.x):
			var point = Vector2(x, y)
			if point in obstacles:
				continue

			points_array.append(point)
			var point_index = calculate_point_index(point)
			astar_node.add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array


func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		# For every cell in the map, we check the one to the top, right.
		# left and bottom of it. If it's in the map and not an obstalce,
		# We connect the current point with it
		var points_relative = PoolVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.x, point.y - 1)])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)

			if is_outside_map_bounds(point_relative):
				continue
			if not astar_node.has_point(point_relative_index):
				continue

			astar_node.connect_points(point_index, point_relative_index, false)


func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func calculate_point_index(point):
	return point.x + map_size.x * point.y


func find_path(world_start, world_end):
	self.path_start_position = world_to_map(world_start)
	self.path_end_position = world_to_map(world_end)
	_recalculate_path()
	var path_world = []
	for point in _point_path:
		var point_world = my_map_to_world(Vector2(point.x, point.y))
		path_world.append(point_world)
	return path_world


func _recalculate_path():
	clear_previous_path_drawing()
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	if astar_node.has_point(start_point_index) && astar_node.has_point(end_point_index):
		_point_path = astar_node.get_point_path(start_point_index, end_point_index)
	# Redraw the lines and circles from the start to the end point


func clear_previous_path_drawing():
	if not _point_path:
		return
	var point_start = _point_path[0]
	var point_end = _point_path[len(_point_path) - 1]


func _draw():
	if not _point_path:
		return
	var point_start = _point_path[0]
	var point_end = _point_path[len(_point_path) - 1]

	var last_point = my_map_to_world(Vector2(point_start.x, point_start.y))
	for index in range(1, len(_point_path)):
		var current_point = my_map_to_world(Vector2(_point_path[index].x, _point_path[index].y))
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
		last_point = current_point
	for x in range(10):
		for y in range(10):
			var pos = my_map_to_world(Vector2(x, y))
			draw_circle(pos, 3.0, Color(0,0,0))


# Setters for the start and end path values.
func _set_path_start_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	path_start_position = value
	if path_end_position and path_end_position != path_start_position:
		_recalculate_path()


func _set_path_end_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	path_end_position = value
	if path_start_position != value:
		_recalculate_path()

func generate_random_path(start_pos):
	var cond = true
	var i = 0
	var rnd_index

	while (cond):
		randomize()
		rnd_index = Vector2(randi()%int(map_size.x),randi()%int(map_size.y))
		if rnd_index in obstacles:
			cond = false

	self.path_start_position = world_to_map(start_pos)
	self.path_end_position = rnd_index
	_recalculate_path()
	var path_world = []
	for point in _point_path:
		var point_world = my_map_to_world(Vector2(point.x, point.y))
		path_world.append(point_world)
	return path_world

func my_map_to_world(index):
	var x = _half_cell_size.x + cell_size.x*index.x
	var y = _half_cell_size.y + cell_size.y*index.y
	return Vector2(x, y)
