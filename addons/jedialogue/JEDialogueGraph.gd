extends Reference
class_name JEDialogueGraph

var nodes: Dictionary#[JEDialogueNode]

func _init():
	nodes = {}

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
