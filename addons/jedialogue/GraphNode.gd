tool
extends GraphNode

var data: JEDialogueNode
var project: JeDialogueProject

const OUTPUT_SCENE := preload("res://addons/jedialogue/GraphNodeOutput.tscn")

func get_num_outputs() -> int:
	return data.outputs.size()

func push_output() -> Control:
	var scene = OUTPUT_SCENE.instance()
	add_child_below_node(scene, get_child(get_num_outputs()))
	return scene

func _ready():
	set_slot(0, true, 0, Color.green, false, 1, Color.red)

func set_data(p_data: JEDialogueNode):
	data = p_data
	self.name = data.name
	self.title = data.name
	self.rect_position = data.position
	self.rect_size = data.size
	for data in p_data.data:
		pass
	for output in p_data.outputs:
		var child = push_output()
#		child.set_label()
