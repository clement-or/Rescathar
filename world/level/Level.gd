extends Node2D

signal is_ready

func _ready():
	# Connect enemies
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.connect("cathare_list_requested", self, "give_cathare_list")
	emit_signal("is_ready")

func give_cathare_list(obj):
	var cathares = $Cathares.get_children()
	obj.cathare_list = cathares

func give_prison(obj):
	obj.prison = $EnemyArea
