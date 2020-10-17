tool
extends Control

onready var node_graph := $Panel/GraphEdit as GraphEdit

func _ready():
	pass

# Scroll the view by 'amount' increments
#func scroll(amount: int, pos: Vector2):
#	var pos_before := (pos - scroll_amount) / TILE_SIZE
#	tile_size_i = int(clamp(tile_size_i + amount, 0, TILE_SIZE_ARRAY.size()-1))
#	TILE_SIZE = TILE_SIZE_ARRAY[tile_size_i]
#	var pos_after := (pos - scroll_amount) / TILE_SIZE
#	scroll_amount += (pos_after - pos_before) * TILE_SIZE
#	node_canvas.update()
#
#var is_scrolling := false
func _on_Panel_gui_input(event: InputEvent):
	pass
#	if event is InputEventMouseMotion:
#		if is_scrolling:
#			scroll_amount += event.relative
#			node_canvas.update()
#	elif event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT:
#			pass
#		elif event.button_index == BUTTON_MIDDLE:
#			is_scrolling = event.pressed
#		elif event.button_index == BUTTON_RIGHT and event.pressed:
##			var pos = pos_to_key(event.position)
##			add_active_tile(pos, true)
##			show_popup(event.global_position)
#			accept_event()
#		elif event.button_index == BUTTON_WHEEL_UP and event.pressed:
#			scroll(1, event.position)
#			accept_event()
#		elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
#			scroll(-1, event.position)
#			accept_event()
