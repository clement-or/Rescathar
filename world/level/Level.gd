extends Node2D

signal is_ready

func _ready():
  $Enemy.connect("cathare_list_requested", self, "give_cathare_list")
  emit_signal("is_ready")

func _on_Enemy_cathare_list_requested(obj):
  var cathares = $Cathares.get_children()
  obj.cathare_list = cathares

func give_prison(obj):
  obj.prison = $EnemyArea
