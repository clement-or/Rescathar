extends NinePatchRect

export var time=10


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time=time
	$TextureProgress.max_value=time
	$Timer.start()
	 # Replace with function body.

func _process(delta):
	$Label.text=String(stepify($Timer.time_left,1))
	$TextureProgress.value=$Timer.time_left
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
