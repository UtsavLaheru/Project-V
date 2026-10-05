extends Area2D
class_name innerDialog

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
		GlobalVariables.gotoNextStage = true
		once = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_intractable = true
