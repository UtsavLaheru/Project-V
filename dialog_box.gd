extends CanvasLayer

@export var CHAR_READ_RATE: float = 0.005
@onready var textbox: Panel = $Panel
@onready var text: Label = $Panel/text
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
enum TextState { READY, READING, FINISHED }
var current_state: TextState
var is_dialogue_active: bool = false
var text_queue: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_textbox()

func _process(delta: float) -> void:
	match current_state:
		TextState.READY:
			if not text_queue.is_empty():
				display_text()
		TextState.READING:
			if Input.is_action_just_pressed("Intract"):
				skip_text()
		TextState.FINISHED:
			if Input.is_action_just_pressed("Intract"):
				advance()

func start_dialogue(lines: Array[String]) -> void:
	if is_dialogue_active:
		return
	is_dialogue_active = true
	text_queue = lines.duplicate()
	change_state(TextState.READY)

# func is_busy() -> bool:
# 	return is_dialogue_active

func skip_text() -> void:
	animationPlayer.stop()
	text.visible_ratio = 1.0
	change_state(TextState.FINISHED)

func advance() -> void:
	if text_queue.is_empty():
		end_dialog()
	else:
		change_state(TextState.READY)

func end_dialog() -> void:
	is_dialogue_active = false
	hide_textbox()
	get_tree().paused = false
	change_state(TextState.READY)


func show_textbox() -> void:
	textbox.show()
	get_tree().paused = true
	text.show()

func hide_textbox() -> void:
	textbox.hide()
	text.hide()

func display_text() -> void:
	var next_text: String = text_queue.pop_front()
	text.text = next_text
	text.visible_ratio = 0.0
	show_textbox()
	change_state(TextState.READING)

	var target_duration: float = max(len(next_text) * CHAR_READ_RATE, 0.01)
	var animation_length: float = animationPlayer.get_animation("Text_Scroll").length
	animationPlayer.speed_scale = animation_length / target_duration
	animationPlayer.play("Text_Scroll")
	
func change_state(next_state: TextState) -> void:
	current_state = next_state
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Text_Scroll":
		change_state(TextState.FINISHED)

# TODO:
# I did't added the busy and check and change the intract system interface in Other Charater.
# PLUS: Make Changes In Intract_Button_Prompt or Suggestion in Player Script.
