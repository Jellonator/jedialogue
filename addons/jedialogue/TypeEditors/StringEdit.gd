extends LineEdit

signal on_type_value_changed(value)

func set_type_value(value: String):
	self.text = value

func _on_LineEdit_text_changed(new_text: String):
	emit_signal("on_type_value_changed", new_text)
