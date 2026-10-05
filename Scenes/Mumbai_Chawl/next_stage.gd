extends Area2D

@export var Next_Stage: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and GlobalVariables.gotoNextStage:
		GlobalVariables.gotoNextStage = false
		if Next_Stage != null:
			get_tree().change_scene_to_packed(Next_Stage)
		else:
			print("Can't Move To Next Stage Because The Given Stage is Null")
