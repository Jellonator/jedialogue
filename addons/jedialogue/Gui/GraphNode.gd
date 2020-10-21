tool
extends GraphNode

const OUTPUT_SCENE := preload("res://addons/jedialogue/Gui/GraphNodeOutput.tscn")\

# Actual data
var data: JEDialogueNode
# Parent graph
var graph: GraphEdit
# List of outputs
var outputs := []

onready var node_data := $Data

# Get this node's project
func get_project() -> JeDialogueProject:
	return graph.get_project()

# Get this node's type data
func get_type() -> JEDialogueNodeType:
	return get_project().datatypes[self.data.datatype]

# Get the number of outputs
func get_num_outputs() -> int:
	return data.outputs.size()

# Get the slot number for the input slot
func get_input_slot() -> int:
	return 0

# Get the slot number for the given output index
func get_output_slot(idx: int) -> int:
	return idx + 1

# Get the target node for the output of index 'idx'
func get_output_target(idx: int) -> String:
	return data.outputs[idx].node_name

# Add one single output to this node
func push_output() -> Control:
	var scene = OUTPUT_SCENE.instance()
	var nodetype := get_type()
	var idx := get_child_count()-1
	add_child(scene)
	move_child(scene, idx)
	set_slot(idx, false, 1, Color.green, true, 0, Color.green)
	outputs.push_back(scene)
	scene.set_label(nodetype.output_extra_name + " " + str(idx))
	var output_index := idx - 1
	for i in range(nodetype.get_num_output_data()):
		var typeinfo := nodetype.get_output_type_info(i)
		var editor := JeDialogueTypeServer.instance_editor(typeinfo.typename)
		scene.add_data(typeinfo.name, editor)
		editor.set_type_value(data.get_output(output_index).get_data(i).value)
		editor.connect("on_type_value_changed", self, "_on_data_value_set", [
			output_index, i])
	return scene

# Refresh buttons to reflect internal state
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

func _ready():
	set_slot(0, true, 0, Color.green, false, 1, Color.red)
#	refresh()
	self.resizable = true

# Get the minimum number of outputs
func get_output_basis() -> int:
	return get_type().num_outputs

# Get the output scale
func get_output_scale() -> int:
	return get_type().output_scale

# Returns true if outputs can be added
func can_push_outputs():
	return get_output_scale() > 0

# Returns true if outputs can be removed
func can_remove_outputs():
	return get_num_outputs() > get_output_basis()

# Deserialize the given data into this node
func set_data(p_data: JEDialogueNode):
	data = p_data
	var typedata := get_type()
	self.name = data.name
	self.title = data.name + ": " + get_type().name
	self.offset = data.position
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

# Initialize connections; use when deserializing
# Essentially copies internal connections into the GraphEdit
func init_connections():
	for i in range(data.outputs.size()):
		var output = data.outputs[i]
		var name = output.node_name
		if name == "":
			continue
		if not name in graph.nodes:
			printerr("COULD NOT FIND NODE ", name)
		else:
			graph.connect_node(self.name, i, name, 0)

# Add an output
func _on_Add_pressed():
	if not can_push_outputs():
		return
	for i in range(get_output_scale()):
		data.push_output(get_type())
		var child = push_output()
	refresh()

# Remove an output
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

# Set the connection of index 'idx' to the given value.
# This does not affect the visual node connections managed by GraphEdit
func set_connection(idx: int, name: String):
	data.outputs[idx].node_name = name

func _on_GraphNode_resize_request(new_minsize):
	self.rect_size = new_minsize
	data.size = new_minsize

func _on_GraphNode_dragged(from, to):
	data.position = to

func _on_data_value_set(value, index: int):
	data.set_data_value(index, value)

func _on_output_value_set(value, output: int, index: int):
	data.set_output_value(output, index, value)
