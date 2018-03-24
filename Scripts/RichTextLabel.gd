extends RichTextLabel

func _ready():
	set_visible_characters(0)
	set_process_input(true)

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		if get_visible_characters() >= get_total_character_count():
			get_parent().hide()
