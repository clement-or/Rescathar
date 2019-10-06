extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Jouer_pressed():
	get_tree().change_scene("res://world/level/Carte1.tscn")
