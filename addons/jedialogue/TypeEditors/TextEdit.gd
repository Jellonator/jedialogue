extends TextEdit

signal on_type_value_changed(value)

func set_type_value(value: String):
	self.text = value

func _on_TextEdit_text_changed():
	emit_signal("on_type_value_changed", self.text)
