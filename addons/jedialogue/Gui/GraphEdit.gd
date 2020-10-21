tool
extends GraphEdit

const SCENE_NODE := preload("res://addons/jedialogue/Gui/GraphNode.tscn")

var nodes := {}

signal show_menu()

func is_name_taken(name: String):
	return name in nodes

func _ready():
	print("BEGIN")
	add_valid_connection_type(0, 0)
	add_valid_left_disconnect_type(0)
	add_valid_right_disconnect_type(0)

func get_project() -> JeDialogueProject:
	return owner.project

func add_node(node_data: JEDialogueNode):
	var child = SCENE_NODE.instance()
	child.graph = self
	prints("CHILD", node_data.name, node_data)
	add_child(child)
	child.set_data(node_data)
	nodes[node_data.name] = child

func load_graph(data: JEDialogueGraph):
	clear_all()
	for node_name in data.nodes.keys():
		var node_data = data.nodes[node_name]
		add_node(node_data)
	# handle connections
	for node in nodes.values():
		node.init_connections()

func clear_all():
	clear_connections()
	for child in nodes.values():
		child.queue_free()
	nodes.clear()

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

func _on_GraphEdit_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			emit_signal("show_menu")
