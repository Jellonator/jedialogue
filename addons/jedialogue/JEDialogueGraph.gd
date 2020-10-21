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

func remove_node(name: String):
	nodes.erase(name)

func rename_node(from: String, value: String):
	# Remove node
	var node := get_node(from)
	remove_node(from)
	# Manage connections of other nodes
	for name in nodes:
		var other := get_node(name)
		for i in range(other.get_num_outputs()):
			var output := other.get_output(i)
			if output.node_name == from:
				output.node_name = value
	# Add node back in
	node.name = value
	add_node(node)

static func deserialize(data: Dictionary) -> JEDialogueGraph:
	var ret = load("res://addons/jedialogue/JEDialogueGraph.gd").new()
	for name in data.keys():
		var value = data[name]
		ret.nodes[name] = JEDialogueNode.deserialize(name, value)
	return ret

func serialize() -> Dictionary:
	var ret := {}
	for name in nodes.keys():
		ret[name] = nodes[name].serialize()
	return ret

func verify(project: JeDialogueProject) -> bool:
	var ret := true
	for name in nodes:
		var value := nodes[name] as JEDialogueNode
		if not value.verify(project):
			ret = false
	return ret
