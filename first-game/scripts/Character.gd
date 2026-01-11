class_name Character
extends Node

enum Name {
	CLONE,
	PLAYER,
	EMPLOYEE,
}

const CHARACTER_DETAILS : Dictionary = {
	Name.CLONE: {
		"name": "Clone",
		"gender": "n/a",
		"sprite_frames": preload("res://resources/clone_sprite.tres")
	},
	Name.PLAYER: {
		"name": "Player",
		"gender": "female",
		"sprite_frames": null
	},
	Name.EMPLOYEE: {
		"name": "Employee",
		"gender": "male",
		"sprite_frames": null
	}
}

static func get_enum_from_string(string_value: String) -> int:
	var upper_string = string_value.to_upper()
	if Name.has(upper_string):
		return Name[upper_string]
	else:
		push_error("Invalid Character name: " + string_value)
		return -1 #or any value to indicate an error
