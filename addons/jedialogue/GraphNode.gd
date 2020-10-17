tool
extends GraphNode

var data: JEDialogueNode
var project: JeDialogueProject
var graph: GraphEdit

const OUTPUT_SCENE := preload("res://addons/jedialogue/GraphNodeOutput.tscn")

func get_num_outputs() -> int:
	return data.outputs.size()

func get_input_slot() -> int:
	return 0

func get_output_slot(idx: int) -> int:
	return idx + 1

func push_output() -> Control:
	var scene = OUTPUT_SCENE.instance()
#	add_child_below_node(scene, get_child(get_num_outputs()))
	var idx := get_child_count()-1
	add_child(scene)
	move_child(scene, idx)
	set_slot(idx, false, 1, Color.green, true, 0, Color.green)
	prints("ADDING OUTPUT", get_child_count(), get_children())
	return scene

func _ready():
	set_slot(0, true, 0, Color.green, false, 1, Color.red)

func set_data(p_data: JEDialogueNode):
	prints("SET DATA", p_data)
	data = p_data
	self.name = data.name
	self.title = data.name
	self.rect_position = data.position
	self.rect_size = data.size
	for data in p_data.data:
		pass
	for output in p_data.outputs:
		var child = push_output()

func init_connections():
	for i in range(data.outputs.size()):
		var output = data.outputs[i]
		var name = output.node_name
		if not name in graph.nodes:
			printerr("COULD NOT FIND NODE ", name)
		else:
			print("CONNECT ", i)
			graph.connect_node(self.name, i, name, 0)
