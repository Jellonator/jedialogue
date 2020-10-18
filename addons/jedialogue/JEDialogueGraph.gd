extends Reference
class_name JEDialogueGraph

var nodes: Dictionary#[JEDialogueNode]

func _init():
	nodes = {}
	
func get_node(name: String) -> JEDialogueNode:
	return nodes[name]

func has_node(name: String) -> bool:
	return name in nodes

func add_node(node: JEDialogueNode):
	nodes[node.name] = node

static func deserialize(data: Dictionary) -> JEDialogueGraph:
	var ret = load("res://addons/jedialogue/JEDialogueGraph.gd").new()
	for name in data.keys():
		var value = data[name]
		ret.nodes[name] = JEDialogueNode.deserialize(name, value)
	return ret

func verify(project: JeDialogueProject) -> bool:
	var ret := true
	for name in nodes:
		var value := nodes[name] as JEDialogueNode
		if not value.verify(project):
			ret = false
	return ret
