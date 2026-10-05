extends Area2D
class_name target

@export var dialogue: Array[String] = []

# or player_in_range
var player_intractable: bool = false
var was_dialogue_active: bool = false
var awaiting_key_release: bool = false
var busy: bool 
var once: bool = true

func _process(delta: float) -> void:
	busy = DialogBox.is_dialogue_active

	if was_dialogue_active and not busy:
		awaiting_key_release = true
	was_dialogue_active = busy

	if awaiting_key_release:
		if not Input.is_action_just_pressed("Intract"):
			awaiting_key_release = false
		return

	if player_intractable and not busy and once:
		DialogBox.start_dialogue(dialogue)
		once = !once

	if once == false:
		$AnimationPlayer.play("GetOutofHere")
		GlobalVariables.FirstDialog = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_intractable = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_intractable = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "GetOutofHere":
		$AnimationPlayer.active = false
		queue_free()
