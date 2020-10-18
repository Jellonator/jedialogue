extends Control

onready var node_label := $VBoxContainer/Label
onready var node_data := $VBoxContainer/Data

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_label(name: String):
	node_label.text = name

func add_data(label: String, child: Node):
	var labelnode := Label.new()
	labelnode.text = label
	node_data.add_child(labelnode)
	node_data.add_child(child)
