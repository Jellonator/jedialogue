tool
extends Node

const JSON_TYPES := [
	TYPE_STRING,
	TYPE_INT,
	TYPE_REAL,
	TYPE_BOOL,
	TYPE_ARRAY,
	TYPE_DICTIONARY
]


class DialogueType:
	# Expected type MUST be JSON-serializable.
	# This means that the type not only must serialize properly, but must also
	# be the same type upon de-serializing.
	var expected_type: int
	# The default value
	var default_value
	# gui_editor is a Scene with the following guarantees:
	# A 'set_type_value' function that takes a value of the given type
	# A 'on_type_value_changed' signal that is emitted when the user changes a value,
	# and returns a single value of the given type.
	var gui_editor: PackedScene
	func _init(p_type: int, p_default, p_editor: PackedScene):
		self.default_value = p_default
		self.expected_type = p_type
		self.gui_editor = p_editor

var types := {}

# Register a new type
func register_type(name: String, value: DialogueType):
	if not value.expected_type in JSON_TYPES:
		push_warning("Type '%s' does not a valid JSON type" % [name])
	if value.expected_type != typeof(value.default_value):
		push_warning("Type '%s' has type %d, but default value has type %d" % [
			name, value.expected_type, typeof(value.default_value)
		])
	types[name] = value

# Return true if the given type exists
func has_type(name: String) -> bool:
	return name in types

# Get the DialogueType for the given type string
func get_type(name: String) -> DialogueType:
	return types[name]

# Instance a new node that can be used to edit a value of the given type.
# The caller is responsible for adding the node to the scene, and managing its
# memory.
func instance_editor(name: String) -> Node:
	return types[name].gui_editor.instance()

# Get an appropriate default value for the given type name
func get_default_value(name: String):
	var value = types[name].default_value

# Verify that the given value is valid for the given type
func verify_type(name: String, value) -> bool:
	var expected_type = types[name].expected_type
	var actual_type = typeof(value)
	if actual_type == TYPE_INT and expected_type == TYPE_REAL:
		return true
	if actual_type == TYPE_REAL and expected_type == TYPE_INT and value == round(value):
		return true
	return expected_type == actual_type

func _ready():
	print("WOW")
	register_type("string", DialogueType.new(TYPE_STRING, "", 
		preload("res://addons/jedialogue/TypeEditors/StringEdit.tscn")))
