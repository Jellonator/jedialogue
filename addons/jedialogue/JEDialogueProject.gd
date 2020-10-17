tool
extends Node
class_name JeDialogueProject

var datatypes: Dictionary#[JEDialogueNodeType]

func _init():
	datatypes = {}

static func deserialize(data: Dictionary) -> JeDialogueProject:
	var ret = load("res://addons/jedialogue/JEDialogueProject.gd").new()
	for name in data.keys():
		var value = data[name]
		ret.datatypes[name] = JEDialogueNodeType.deserialize(name, value)
	return ret

func serialize() -> Dictionary:
	var ret := {}
	for key in datatypes.keys():
		ret[key.name] = key.serialize()
	return ret
