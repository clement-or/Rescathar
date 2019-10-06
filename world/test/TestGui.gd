extends Control

func _on_Player_score_changed(score):
  $Label.text = score
