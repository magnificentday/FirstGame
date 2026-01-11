class_name DialogueUI
extends Control

signal text_animation_done

@onready var dialog_line = $DialogueBox/DialogueLine
@onready var speaker_name = %SpeakerName

const ANIMATION_SPEED : int = 30
var animate_text: bool = false
var current_visible_characters : int = 0
var current_character_details: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animate_text:
		if dialog_line.visible_ratio < 1:
			dialog_line.visible_ratio += (1.0/len(dialog_line.text)) * (ANIMATION_SPEED * delta)
			if dialog_line.visible_characters > current_visible_characters:
				current_visible_characters = dialog_line.visible_characters
		else:
			animate_text = false
			text_animation_done.emit()

func change_line(speaker : String, line: String):
	speaker_name.text = speaker
	current_visible_characters = 0
	dialog_line.text = line
	dialog_line.visible_characters = 0
	animate_text = true
	
func skip_text_animation():
	dialog_line.visible_ratio = 1
	
func set_speaker_name_text():
	pass
