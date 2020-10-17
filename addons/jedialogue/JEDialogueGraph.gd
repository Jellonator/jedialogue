extends Reference
class_name JEDialogueGraph

var nodes: Dictionary#[JEDialogueNode]

func deserialize(data: Dictionary):
	var ret = load("res://addons/jedialogue/JEDialogueGraph.gd").new()
	for name in data.keys():
		var value = data[name]
		ret.nodes[name] = JEDialogueNode.deserialize(name, value)
	return ret
