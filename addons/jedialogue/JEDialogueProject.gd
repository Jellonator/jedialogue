tool
extends Node
class_name JeDialogueProject

var datatypes: Dictionary#[JEDialogueNodeType]

func _init():
	datatypes = {}

func has_type(name: String) -> bool:
	return name in datatypes

func get_type(name: String) -> JEDialogueNodeType:
	return datatypes[name]

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

func verify() -> bool:
	var ret := true
	for name in datatypes:
		var value := datatypes[name] as JEDialogueNodeType
		if not value.verify():
			ret = false
	return ret
