tool
extends GraphNode

var data: JEDialogueNode
var graph: GraphEdit
var outputs := []

onready var node_data := $Data

func get_project() -> JeDialogueProject:
	return graph.get_project()

func get_type() -> JEDialogueNodeType:
	return get_project().datatypes[self.data.datatype]

const OUTPUT_SCENE := preload("res://addons/jedialogue/GraphNodeOutput.tscn")

func get_num_outputs() -> int:
	return data.outputs.size()

func get_input_slot() -> int:
	return 0

func get_output_slot(idx: int) -> int:
	return idx + 1

func get_output_target(idx: int) -> String:
	return data.outputs[idx].node_name

func push_output() -> Control:
	var scene = OUTPUT_SCENE.instance()
#	add_child_below_node(scene, get_child(get_num_outputs()))
	var idx := get_child_count()-1
	add_child(scene)
	move_child(scene, idx)
	set_slot(idx, false, 1, Color.green, true, 0, Color.green)
	prints("ADDING OUTPUT", get_child_count(), get_children())
	outputs.push_back(scene)
	return scene

func refresh():
	if can_push_outputs():
		$Buttons/Add.disabled = false
		$Buttons/Add.show()
	else:
		$Buttons/Add.disabled = true
		$Buttons/Add.hide()
	if can_remove_outputs():
		$Buttons/Remove.disabled = false
		$Buttons/Remove.show()
	else:
		$Buttons/Remove.disabled = true
		$Buttons/Remove.hide()
	prints("NUM:", get_num_outputs())

func _ready():
	set_slot(0, true, 0, Color.green, false, 1, Color.red)
#	refresh()
	self.resizable = true

func get_output_basis() -> int:
	return get_type().num_outputs

func get_output_scale() -> int:
	return get_type().output_scale

func can_push_outputs():
	return get_output_scale() > 0

func can_remove_outputs():
	return get_num_outputs() > get_output_basis()

func set_data(p_data: JEDialogueNode):
	prints("SET DATA", p_data)
	data = p_data
	var typedata := get_type()
	self.name = data.name
	self.title = data.name + ": " + get_type().name
	self.rect_position = data.position
	self.rect_size = data.size
	for i in p_data.data.size():
		var typeinfo := typedata.get_data_type_info(i)
#		var dialoguetype = JeDialogueTypeServer.get_type(typeinfo.typename)
		var label := Label.new()
		label.text = typeinfo.name
		var editor := JeDialogueTypeServer.instance_editor(typeinfo.typename)
		node_data.add_child(label)
		node_data.add_child(editor)
		editor.set_type_value(p_data.data[i].value)
		editor.connect("on_type_value_changed", self, "_on_data_value_set", [i])
	for output in p_data.outputs:
		var child = push_output()
	refresh()

func init_connections():
	for i in range(data.outputs.size()):
		var output = data.outputs[i]
		var name = output.node_name
		if name == "":
			continue
		if not name in graph.nodes:
			printerr("COULD NOT FIND NODE ", name)
		else:
			print("CONNECT ", i)
			graph.connect_node(self.name, i, name, 0)

func _on_Add_pressed():
	if not can_push_outputs():
		return
	for i in range(get_output_scale()):
		data.push_output(get_type())
		var child = push_output()
	refresh()

func _on_Remove_pressed():
	if not can_remove_outputs():
		return
	for i in range(get_output_scale()):
		var idx = outputs.size() - 1
		set_slot(idx+1, false, 1, Color.green, false, 0, Color.green)
		if get_output_target(idx) != "":
			graph.disconnect_node(self.name, idx, get_output_target(idx), 0)
		data.outputs.pop_back()
		outputs.back().queue_free()
		outputs.pop_back()
	refresh()

func set_connection(idx: int, name: String):
	data.outputs[idx].node_name = name
	prints("CONNECTION", idx, name)

func _on_GraphNode_resize_request(new_minsize):
	self.rect_size = new_minsize
	data.size = new_minsize

func _on_GraphNode_dragged(from, to):
	data.position = to

func _on_data_value_set(value, index: int):
	data.set_data_value(index, value)
	prints("Set", index, "to", value)

func _on_output_value_set(value, output: int, index: int):
	data.set_output_value(output, index, value)
