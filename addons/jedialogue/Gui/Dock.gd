tool
extends Control

const MENU_PROJECT_OPEN := 0

const MENU_FILE_NEW := 0
const MENU_FILE_OPEN := 1
const MENU_FILE_SAVE := 2
const MENU_FILE_SAVE_AS := 3
const MENU_FILE_CLOSE := 4

const MENU_EDIT_CREATE := 0

const RIGHTCLICK_MENU_CREATE := 0
const RIGHTCLICK_MENU_DELETE := 1
const RIGHTCLICK_MENU_RENAME := 2

var project: JeDialogueProject
var graph: JEDialogueGraph

onready var node_graph := $VBox/Panel/GraphEdit as GraphEdit
onready var node_menu_project := $VBox/HBox/MenuProject as MenuButton
onready var node_menu_file := $VBox/HBox/MenuFile as MenuButton
onready var node_menu_edit := $VBox/HBox/MenuEdit as MenuButton
onready var node_right_click_menu := $RightClickMenu as PopupMenu
onready var node_create_node_dialogue := $CreateNodeDialog as ConfirmationDialog
onready var node_project_open_dialog := $ProjectOpenDialog as FileDialog
onready var node_file_open_dialog := $FileOpenDialog as FileDialog
onready var node_file_save_dialog := $FileSaveDialog as FileDialog

func delete_node(name: String):
	graph.remove_node(name)

func is_name_taken(name: String):
	return node_graph.is_name_taken(name)

func is_valid_name(name: String) -> bool:
	if name == "":
		return false
	return not is_name_taken(name)

func load_project(data: Dictionary):
	var newproject := JeDialogueProject.deserialize(data)
	if newproject == null:
		printerr("COULD NOT LOAD PROJECT")
		return
	project = newproject
	node_create_node_dialogue.set_project(project)
	# Clear graph
	graph = JEDialogueGraph.new()
	node_graph.clear_all()
	update_buttons()

func load_file(data: Dictionary):
	var newfile := JEDialogueGraph.deserialize(data)
	if newfile == null:
		printerr("COULD NOT LOAD FILE")
		return
	graph = newfile
	node_graph.load_graph(graph)
	update_buttons()

func update_buttons():
	node_menu_file.disabled = project == null
	node_menu_edit.disabled = project == null
	node_right_click_menu.set_item_disabled(RIGHTCLICK_MENU_CREATE, project == null)
	node_right_click_menu.set_item_disabled(RIGHTCLICK_MENU_DELETE, project == null)

func _ready():
	if not Engine.editor_hint:
		initialize()

func initialize():
	node_menu_project.get_popup().connect("id_pressed", self, "_on_menu_project_pressed")
	node_menu_file.get_popup().connect("id_pressed", self, "_on_menu_file_pressed")
	node_menu_edit.get_popup().connect("id_pressed", self, "_on_menu_edit_pressed")
	update_buttons()

func do_project_open():
	node_project_open_dialog.popup_centered()

func _on_menu_project_pressed(id: int):
	match id:
		MENU_PROJECT_OPEN:
			do_project_open()
		_:
			pass

func do_file_new():
	graph = JEDialogueGraph.new()
	node_graph.clear_all()

func do_file_open():
	node_file_open_dialog.popup_centered()

func do_file_save_as():
	node_file_save_dialog.popup_centered()

func _on_menu_file_pressed(id: int):
	match id:
		MENU_FILE_NEW:
			do_file_new()
		MENU_FILE_OPEN:
			do_file_open()
		MENU_FILE_SAVE:
			do_file_save_as()
		MENU_FILE_SAVE_AS:
			do_file_save_as()
		MENU_FILE_CLOSE:
			pass

var create_position := Vector2.ZERO
func do_edit_create():
	node_create_node_dialogue.popup_centered()

func _on_menu_edit_pressed(id: int):
	match id:
		MENU_EDIT_CREATE:
			var scrollpos = node_graph.scroll_offset / node_graph.zoom
			create_position = scrollpos + (node_graph.rect_size / node_graph.zoom) / 2.0
			do_edit_create()

func _on_GraphEdit_show_menu():
	var pos := get_local_mouse_position() - Vector2.ONE * 8
	node_right_click_menu.popup(Rect2(pos, Vector2.ONE))

func do_edit_delete():
	node_graph._on_GraphEdit_delete_nodes_request()

func _on_RightClickMenu_id_pressed(id):
	match id:
		RIGHTCLICK_MENU_CREATE:
			var scrollpos = node_graph.scroll_offset / node_graph.zoom
			create_position = node_graph.get_local_mouse_position() / node_graph.zoom + scrollpos
			do_edit_create()
		RIGHTCLICK_MENU_DELETE:
			do_edit_delete()

func _on_CreateNodeDialogue_create_dialogue(name, typename):
	var typedata = project.get_type(typename)
	var newnode := JEDialogueNode.construct_empty(name, typedata)
	newnode.position = create_position - Vector2.ONE * 8
	graph.add_node(newnode)
	node_graph.add_node(newnode)
	prints("CREATING", name, typename, create_position)

func _on_ProjectOpenDialog_file_selected(path: String):
	var project_file := File.new()
	project_file.open(path, File.READ)
	var project_data = JSON.parse(project_file.get_as_text()).result
	load_project(project_data)

func _on_FileOpenDialog_file_selected(path: String):
	var graph_file := File.new()
	graph_file.open(path, File.READ)
	var graph_data = JSON.parse(graph_file.get_as_text()).result
	load_file(graph_data)

func _on_FileSaveDialog_file_selected(path: String):
	var data := graph.serialize()
	var json := JSON.print(data, "\t", true)
	var fh := File.new()
	var err = fh.open(path, File.WRITE)
	fh.store_string(json)
