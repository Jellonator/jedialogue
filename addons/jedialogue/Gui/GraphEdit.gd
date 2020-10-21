tool
extends GraphEdit

const SCENE_NODE := preload("res://addons/jedialogue/Gui/GraphNode.tscn")

# Maps node names to the GraphNode values
var nodes := {}
# A list of currently selected nodes
var selected_nodes := []
# Signal that is emitted when the user right clicks
signal show_menu()

func rename_node(from: String, value: String):
	# Remove connections
	var ls := []
	for connection in get_connection_list():
		connection = connection.duplicate() # juuuuuust in case
		if connection["from"] == from:
			disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
			connection["from"] = value
			ls.append(connection)
		elif connection["to"] == from:
			disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
			connection["to"] = value
			ls.append(connection)
	# Rename node
	var node = nodes[from]
	nodes.erase(from)
	nodes[value] = node
	node.rename(value)
	# Re-add connections
	for connection in ls:
		connect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])

# Returns true if the given name is already used by an existing node
func is_name_taken(name: String):
	return name in nodes

func _ready():
	add_valid_connection_type(0, 0)
	add_valid_left_disconnect_type(0)
	add_valid_right_disconnect_type(0)

# Get the project data
func get_project() -> JeDialogueProject:
	return owner.project

# Add a new node to this graph
func add_node(node_data: JEDialogueNode):
	var child = SCENE_NODE.instance()
	child.graph = self
	add_child(child)
	child.set_data(node_data)
	nodes[node_data.name] = child

# Load an entirely new graph
func load_graph(data: JEDialogueGraph):
	clear_all()
	yield(get_tree(), "idle_frame")
	for node_name in data.nodes.keys():
		var node_data = data.nodes[node_name]
		add_node(node_data)
	# handle connections
	for node in nodes.values():
		node.init_connections()

# Remove all nodes and connections
func clear_all():
	clear_connections()
	for child in nodes.values():
		child.queue_free()
	nodes.clear()
	selected_nodes.clear()

# Get an array of nodes that have been selected
func get_selected_nodes() -> Array:
	return selected_nodes

# Remove all connections for the given node
func remove_all_connections_for_node(node: GraphNode):
	for connection in get_connection_list():
		if connection["from"] == node.name or connection["to"] == node.name:
			disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
			nodes[connection["from"]].set_connection(connection["from_port"], "")

# Delete a node from this graph
func delete_node(node: GraphNode):
	prints("DELETING", node.name)
	remove_all_connections_for_node(node)
	node.queue_free()
	nodes.erase(node.name)
	owner.delete_node(node.name)
	_on_GraphEdit_node_unselected(node)

func _on_GraphEdit_delete_nodes_request():
	for node in selected_nodes.duplicate(false):
		delete_node(node)

func _on_GraphEdit_popup_request(position):
	emit_signal("show_menu")

func _on_GraphEdit_node_selected(node):
	if node in selected_nodes:
		return
	selected_nodes.append(node)
	prints("SELECT", node)
	owner.update_buttons()

func _on_GraphEdit_node_unselected(node):
	if node in selected_nodes:
		selected_nodes.erase(node)
		prints("DESELECT", node)
		owner.update_buttons()

func _on_GraphEdit_connection_request(from: String, from_slot: int, to: String, to_slot: int):
	# remove existing connection(s)
	# Each output(from) may only connect to one input(to)
	for connection in get_connection_list():
		if connection["from"] == from and connection["from_port"] == from_slot:
			disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
			nodes[connection["from"]].set_connection(connection["from_port"], "")
	connect_node(from, from_slot, to, to_slot)
	nodes[from].set_connection(from_slot, to)

func _on_GraphEdit_disconnection_request(from: String, from_slot: int, to: String, to_slot: int):
	disconnect_node(from, from_slot, to, to_slot)
	nodes[from].set_connection(from_slot, "")
