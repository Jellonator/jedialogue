extends ConfirmationDialog

onready var node_name := $GridContainer/Name as LineEdit
var node := ""

signal rename_node(from, value)

func set_target_node(name: String):
	node = name

func _on_CreateNodeDialogue_confirmed():
	emit_signal("rename_node", node, node_name.text)

func update_button():
	get_ok().disabled = not owner.is_valid_name(node_name.text)

func _on_Name_text_changed(_new_text):
	update_button()

func _on_CreateNodeDialogue_about_to_show():
	update_button()
	node_name.text = node
