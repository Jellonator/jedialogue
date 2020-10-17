tool
extends GraphEdit

func _ready():
	print("BEGIN")
	add_valid_connection_type(0, 0)
	add_valid_left_disconnect_type(0)
	add_valid_right_disconnect_type(0)
#	print("READY")
#	var a = $GraphNode
#	var b = $GraphNode2
#	var c = $GraphNode3
#	a.set_slot(0,
#	true, 0, Color.red,
#	true, 0, Color.red)
#	b.set_slot(0,
#	true, 0, Color.red,
#	true, 0, Color.red)
#	c.set_slot(0,
#	true, 0, Color.red,
#	true, 0, Color.red)

func _on_GraphEdit_connection_request(from: String, from_slot: int, to: String, to_slot: int):
	# remove existing connection(s)
	# Each output(from) may only connect to one input(to)
	for connection in get_connection_list():
		if connection["from"] == from and connection["from_port"] == from_slot:
			disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
	connect_node(from, from_slot, to, to_slot)

func _on_GraphEdit_disconnection_request(from: String, from_slot: int, to: String, to_slot: int):
	disconnect_node(from, from_slot, to, to_slot)
