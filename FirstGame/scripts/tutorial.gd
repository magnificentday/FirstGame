extends Node2D

@onready var character = %CharacterSprite
@onready var dialogue_ui = $CanvasLayer2/DialogueUI

var dialog_index : int = 0

var dialog_lines : Array = []
# var dialog_lines = {
	# {"speaker": "Employee", "text": "Greetings. This is a training regiment required for your future endeavors"},
	# {"speaker": "Employee", "text": "Please listen carefully."},
	# {"speaker": "Employee", "text": "This is a mannequin."},
	# {"speaker": "Employee", "text": "The default looks a little... bland, don't you think?"},
	# {"speaker": "Employee", "text": "Change the mannequin's shirt to a red one."},
# }

# Called when the node enters the scene tree for the first time.
func _ready():
	# load dialogue
	dialog_lines = load_dialog("res://resources/story/story.json")
	print_debug(dialog_lines)
	# connect signals
	dialogue_ui.text_animation_done.connect(_on_text_animation_done)
	#  Process first line of dialogue
	dialog_index = 0
	process_current_line()

func _input(event) :
	if event.is_action_pressed("next_line"):
		if dialogue_ui.animate_text:
			dialogue_ui.skip_text_animation()
		else:
			if dialog_index <len(dialog_lines) - 1:
				dialog_index += 1
				process_current_line()
				
func parse_line(line:String):
	var line_info
func process_current_line():
	var line = dialog_lines[dialog_index]
	# check if it is a goto command
	if line.has ("goto"):
		dialog_index = get_anchor_position(line["goto"])
		process_current_line()
		print(dialog_index)
		return
	# check if this is just an anchor declaration (not displayable content)
	if line.has("anchor"):
		dialog_index += 1
		process_current_line()
		return
	# reading the line of dialogue
		# var line_info = parse_line(line)
	var character_name = Character.get_enum_from_string(line["speaker"])
	dialogue_ui.change_line(line["speaker"], line["text"])
	# character_sprite.change_character(character_name)
	# dialogue_ui.speaker_name.text = "speaker_name"
	# dialogue_ui.dialogue_line.text = "dialogue_line"
	# dialogue_ui.change_line(line_info["speaker_name"], line_info["dialog_line"])
	# character.change_character(character_name)
func get_anchor_position(anchor: String):
	# find the anchor entry with matching name
	for i in range(dialog_lines.size()):
		if dialog_lines[i].has("anchor") and dialog_lines[i]["anchor"] == "anchor":
			return i 
			
	# if we get here, the anchor wasn't found
	printerr("Error: Could not find anchor" + anchor + "")
	return 0

func _on_text_animation_done():
	pass

func load_dialog(file_path):
	#check if the file exists 
	if not FileAccess.file_exists(file_path):
		printerr("Error: File does not exist: ", file_path)
		return null
		
	# open the file
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		printerr("Error: Could not open the file: ", file_path)
		return null
	# read the content as text
	var content = file.get_as_text()
	
	# parse the JSON
	var json_content = JSON.parse_string(content)
	
	# Check if parsing was successful
	if json_content == null:
		printerr("Error: Failed to parse JSON from file: ", file_path)
		return null
	
	# return the dialogue
	return json_content
