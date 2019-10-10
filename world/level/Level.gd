extends Node2D

var cathare = preload("res://characters/cathare/Cathare.tscn")

signal is_ready

func _ready():
	# Connect enemies
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.connect("cathare_list_requested", self, "give_cathare_list")
		enemy.cathare_list = $Game/Cathares.get_children()

func give_prison(obj):
	obj.prison = $EnemyArea


func _on_CathareTimer_timeout():
	pass
	
