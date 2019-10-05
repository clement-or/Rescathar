extends "res://characters/Character.gd"

func _process(delta):
  move(delta)

func get_movedir():
  direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
  direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))

  if direction.x != 0 && direction.y != 0:
    direction = Vector2.ZERO

  # Cast ray
  .get_movedir()

var has_bumped = false
func bump():
  .bump()
  """
  if !has_bumped:
    Anim.play("bump_right")
    has_bumped = true
  """

func _input(event):
  if event.is_action_pressed("right") ||event.is_action_pressed("down") \
  || event.is_action_pressed("left") || event.is_action_pressed("up"):
    has_bumped = false
