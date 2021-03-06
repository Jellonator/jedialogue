extends ConfirmationDialog

onready var node_name := $GridContainer/Name as LineEdit
onready var node_type := $GridContainer/Type as OptionButton

signal create_dialogue(name, typename)

var project: JeDialogueProject

func set_project(p_project: JeDialogueProject):
	project = p_project
	node_type.clear()
	for typename in project.datatypes:
		node_type.add_item(typename)
		node_type.set_item_metadata(node_type.get_item_count()-1, typename)

func _on_CreateNodeDialogue_confirmed():
	var typename = node_type.get_item_metadata(node_type.selected)
	emit_signal("create_dialogue", node_name.text, typename)

func update_button():
	get_ok().disabled = not owner.is_valid_name(node_name.text)

func _on_Name_text_changed(_new_text):
	update_button()

func _on_CreateNodeDialogue_about_to_show():
	update_button()
