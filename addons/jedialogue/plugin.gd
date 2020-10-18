tool
extends EditorPlugin

var dock

func _enter_tree():
	print("ENTER")
	dock = preload("res://addons/jedialogue/Dock.tscn").instance()
	add_control_to_bottom_panel(dock, "Dialogue Editor")
	dock.initialize()
#	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL, dock)

func _exit_tree():
	print("EXIT")
	remove_control_from_bottom_panel(dock)
#	remove_control_from_docks(dock)
	dock.free()
	dock = null
