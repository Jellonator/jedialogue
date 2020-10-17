tool
extends Reference
class_name JEDialogueNodeType

# Name of the node
var name: String
# Base number of outputs
var num_outputs: int
# Amount that number of outputs can scale
# Number of outputs must match O = N + M * K,
# where O is the number of outputs (>=0), N is num_outputs(>=0),
# M is output_scale(>=0), and K is any whole number.
# if N=3 and M=2, then O can be 3, 5, 7, etc...
# If N=3 and M=0, then O can only be 3.
var output_scale: int
# Types of data associated with outputs
var output_data: Array#[TypeInfo]
# Types of data associated with node
var node_data: Array#[TypeInfo]
# Name used for extra nodes
var output_extra_name: String

class TypeInfo:
	var name: String
	var typename: String
	func _init(p_name: String, p_typename: String):
		self.typename = p_typename
	const JSON_TYPENAME := "type"
	const JSON_NAME := "name"
	static func deserialize(data: Dictionary) -> TypeInfo:
		return TypeInfo.new(data[JSON_NAME], data[JSON_TYPENAME])
	func serialize() -> Dictionary:
		return {
			JSON_TYPENAME: self.typename,
			JSON_NAME: self.name
		}

func _init(p_name: String, p_outputs: int, p_outscale):
	self.name = p_name
	self.num_outputs = p_outputs
	self.output_scale = p_outscale
	self.output_data = []
	self.node_data = []
#	self.output_node_names = []
	self.output_extra_name = "Output"

#const JSON_NAME := "name"
const JSON_OUTPUTS := "num_outputs"
const JSON_OUTSCALE := "num_output_scale"
const JSON_DATA_OUTPUT := "data_output"
const JSON_DATA_NODE := "data_node"
static func deserialize(name: String, data: Dictionary) -> JEDialogueNodeType:
	print(name, data)
	var ret = load("res://addons/jedialogue/JEDialogueNodeType.gd").new(
		name, data[JSON_OUTPUTS], data[JSON_OUTSCALE])
	for value in data[JSON_DATA_OUTPUT]:
		ret.output_data.push_back(TypeInfo.deserialize(value))
	for value in data[JSON_DATA_NODE]:
		ret.node_data.push_back(TypeInfo.deserialize(value))
	return ret

func serialize() -> Dictionary:
	var ret := {}
#	ret[JSON_NAME] = self.name
	ret[JSON_OUTPUTS] = self.num_outputs
	ret[JSON_OUTSCALE] = self.output_scale
	ret[JSON_DATA_OUTPUT] = []
	for value in self.output_data:
		ret[JSON_DATA_OUTPUT].push_back(value.serialize())
	ret[JSON_DATA_NODE] = []
	for value in self.node_data:
		ret[JSON_DATA_NODE].push_back(value.serialize())
	return ret
