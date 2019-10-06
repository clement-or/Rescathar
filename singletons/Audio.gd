extends Node2D

func play(name):
  var audio_stream = get_node(name)
  assert(audio_stream)
  audio_stream.play()

func stop(name):
  var audio_stream = get_node(name)
  assert(audio_stream)
  audio_stream.stop()
