extends Area2D
class_name  Intractable_Character

@export var dialogue: Array[String] = []

# or player_in_range
var player_intractable: bool = false
var was_dialogue_active: bool = false
var awaiting_key_release: bool = false
var busy: bool
var once: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	busy = DialogBox.is_dialogue_active

	if was_dialogue_active and not busy:
		awaiting_key_release = true
	was_dialogue_active = busy

	if awaiting_key_release:
		if not Input.is_action_just_pressed("Intract"):
			awaiting_key_release = false
		return

	if player_intractable and not busy and Input.is_action_just_pressed("Intract"):
		if once:
			GlobalVariables.FirstDialog = true
			once = false
		DialogBox.start_dialogue(dialogue)
		dialogue.clear()
		dialogue.push_front("Now Hurry, What Are You Waiting For...")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_intractable = true
		GlobalVariables.Intract_Prompt = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_intractable = false
		GlobalVariables.Intract_Prompt = false
		GlobalVariables.gotoNextStage = true
