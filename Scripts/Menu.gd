extends Polygon2D

var currentOption = 0
var options
var pointer

func _ready():
	options = $Options.get_children()
	pointer = $Pointer
	updatePointer()

func _input(event):
	if Input.is_action_pressed("ui_down"):
		currentOption += 1
		
		if currentOption >= options.size():
			currentOption = 0
	
	if Input.is_action_pressed("ui_up"):
		currentOption -= 1
		
		if currentOption < 0:
			currentOption = options.size() - 1
	
	if Input.is_action_pressed("ui_accept"):
		print("Option: ", options[currentOption].get_name())
		
	if Input.is_action_pressed("ui_cancel"):
		global.UI.toggleMenu()
	
	updatePointer()
		
func updatePointer():
	var offSetForCentering = 30
	var position = Vector2(pointer.get_global_position().x, 
		options[currentOption].get_global_position().y + offSetForCentering)
	pointer.set_global_position(position)
