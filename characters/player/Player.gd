extends "res://characters/Character.gd"

onready var audio = get_node("/root/Audio")

signal score_changed

var cathare_inventory = 0
var score = 0 setget set_score

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

func _on_Player_area_entered(area):
  if cathare_inventory < 3 && area.is_type("Cathare"):
    area.queue_free()
    cathare_inventory += 1

  if area.is_in_group("saving_area"):
    save()

func save():
  if cathare_inventory > 0:
    audio.play("Save")
  score += cathare_inventory*100
  cathare_inventory = 0

func set_score(s):
  score = s
  emit_signal("score_changed", score)
