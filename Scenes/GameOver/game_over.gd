extends CanvasLayer

@export var ContinueFromScene: String = "res://Scenes/Metro/metro.tscn"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		get_tree().change_scene_to_file(ContinueFromScene)
