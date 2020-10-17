tool
extends Control

var project: JeDialogueProject
var graph: JEDialogueGraph

onready var node_graph := $VBox/Panel/GraphEdit as GraphEdit

func load_project(data: Dictionary):
	var newproject := JeDialogueProject.deserialize(data)
	if newproject == null:
		printerr("COULD NOT LOAD PROJECT")
		return
	project = newproject
	# Clear graph
	graph = JEDialogueGraph.new()
	node_graph.clear_all()

func load_file(data: Dictionary):
	var newfile := JEDialogueGraph.deserialize(data)
	if newfile == null:
		printerr("COULD NOT LOAD FILE")
		return
	graph = newfile
	node_graph.load_graph(graph)

func _ready():
#	pass
	print("LOADING PROJECT")
	var project_file := File.new()
	project_file.open("/home/jellonator/Workspace/RealWork/Haru/haruweb/src/projectdata.json", File.READ)
	var project_data = JSON.parse(project_file.get_as_text()).result
	load_project(project_data)
	print("LOADING GRAPH")
	var graph_file := File.new()
	graph_file.open("/home/jellonator/Workspace/RealWork/Haru/haruweb/src/game.json", File.READ)
	var graph_data = JSON.parse(graph_file.get_as_text()).result
	load_file(graph_data)

func _on_Panel_gui_input(event: InputEvent):
	pass
