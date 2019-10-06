extends CanvasLayer

onready var Anim = $Overlay/Anim

func change_scene(path):
  Anim.play("fade")
  yield(Anim, "animation_finished")
  get_tree().change_scene(path)
  Anim.play_backwards("fade")

func quit():
  Anim.play("fade")
  yield(Anim, "animation_finished")
  get_tree().quit()
