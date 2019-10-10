extends Control

var cur_cathares = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	$Label.text = String(cur_cathares)



func _on_Player_score_changed(new_score):
	$CompteCathares/Label.text = new_score


func _on_Player_cathares_changed(new):
	cur_cathares = new
