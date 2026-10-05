extends AudioStreamPlayer

func _process(delta: float) -> void:
	if GlobalVariables.FirstDialog:
		GlobalVariables.FirstDialog = false
		play()
		await get_tree().create_timer(38).timeout
		pitch_scale = 1.1
