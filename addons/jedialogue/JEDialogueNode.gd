tool
extends Reference
class_name JEDialogueNode

var name: String
var datatype: String
var position: Vector2
var size: Vector2
var outputs: Array#[OutputData]
var data: Array#[NodeData]

func _init():
	self.name = ""
	self.datatype = ""
	self.position = Vector2.ZERO
	self.size = Vector2(128, 128)
	self.outputs = []
	self.data = []

class NodeData:
	var value
	func _init(p_value):
		self.value = p_value
	const JSON_VALUE := "value"
	static func deserialize(data: Dictionary) -> NodeData:
		return NodeData.new(data[JSON_VALUE])
	func serialize() -> Dictionary:
		return {
			JSON_VALUE: self.value
		}

class OutputData:
	var node_name: String
	var data: Array#[NodeData]
	func _init(p_name: String):
		self.node_name = p_name
		self.data = []
	const JSON_NODE_NAME := "node_name"
	const JSON_DATA := "data"
	static func deserialize(data: Dictionary) -> OutputData:
		var ret := OutputData.new(data[JSON_NODE_NAME])
		for value in data[JSON_DATA]:
			ret.data.push_back(NodeData.deserialize(value))
		return ret
	func serialize() -> Dictionary:
		var data_array := []
		for value in self.data:
			data_array.push_back(value.serialize())
		return {
			JSON_NODE_NAME: self.node_name,
			JSON_DATA: data_array
		}

#const JSON_NAME := "name"
const JSON_TYPE := "type"
const JSON_X := "x"
const JSON_Y := "y"
const JSON_WIDTH := "width"
const JSON_HEIGHT := "height"
const JSON_OUTPUTS := "outputs"
const JSON_DATA := "data"

static func deserialize(name: String, data: Dictionary) -> JEDialogueNode:
	var ret = load("res://addons/jedialogue/JEDialogueNode.gd").new()
#	ret.name = data[JSON_NAME]
	ret.name = name
	ret.datatype = data[JSON_TYPE]
	if JSON_X in data:
		ret.position.x = data[JSON_X]
	if JSON_Y in data:
		ret.position.y = data[JSON_Y]
	if JSON_WIDTH in data:
		ret.size.x = data[JSON_WIDTH]
	if JSON_HEIGHT in data:
		ret.size.y = data[JSON_HEIGHT]
	for value in data[JSON_OUTPUTS]:
		ret.outputs.push_back(OutputData.deserialize(value))
	for value in data[JSON_DATA]:
		ret.data.push_back(NodeData.deserialize(value))
	return ret

func serialize() -> Dictionary:
	var output_arr := []
	for value in self.outputs:
		output_arr.push_back(value.serialize())
	var data_arr := []
	for value in self.data:
		data_arr.push_back(value.serialize())
	return {
#		JSON_NAME: self.name,
		JSON_TYPE: self.datatype,
		JSON_X: self.position.x,
		JSON_Y: self.position.y,
		JSON_WIDTH: self.size.x,
		JSON_HEIGHT: self.size.y,
		JSON_OUTPUTS: output_arr,
		JSON_DATA: data_arr
	}
