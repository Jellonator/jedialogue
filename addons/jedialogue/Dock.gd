tool
extends Control

const MENU_PROJECT_OPEN := 0
const MENU_FILE_NEW := 0
const MENU_FILE_OPEN := 1
const MENU_FILE_SAVE := 2
const MENU_FILE_SAVE_AS := 3
const MENU_FILE_CLOSE := 4

var project: JeDialogueProject
var graph: JEDialogueGraph

onready var node_graph := $VBox/Panel/GraphEdit as GraphEdit
onready var node_menu_project := $VBox/HBox/MenuProject as MenuButton
onready var node_menu_file := $VBox/HBox/MenuFile as MenuButton

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
	if not Engine.editor_hint:
		initialize()

func initialize():
	node_menu_project.get_popup().connect("id_pressed", self, "_on_menu_project_pressed")
	node_menu_file.get_popup().connect("id_pressed", self, "_on_menu_file_pressed")
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

func _on_menu_project_pressed(id: int):
	match id:
		MENU_PROJECT_OPEN:
			pass
		_:
			pass

func _on_menu_file_pressed(id: int):
	match id:
		MENU_FILE_NEW:
			pass
		MENU_FILE_OPEN:
			pass
		MENU_FILE_SAVE:
			pass
		MENU_FILE_SAVE_AS:
			pass
		MENU_FILE_CLOSE:
			pass
