extends AudioStreamPlayer2D

func _process(delta: float) -> void:
	if GlobalVariables.FirstDialog:
		GlobalVariables.FirstDialog = false
		play()
