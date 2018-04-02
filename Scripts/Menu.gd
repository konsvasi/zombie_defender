extends Polygon2D

const ITEM_LABEL_SCENE = preload("res://Scenes/ItemLabel.tscn")

var currentOption = 0
var currentMenu = "mainMenu"
var options
var items
var pointer
var justOpened
var currentArray

func _ready():
	set_process_input(true)
	justOpened = true
	options = $Options/OptionsContainer.get_children()
	pointer = $Pointer
	setInventoryOption()
	updatePointer()
	currentArray = options
	currentMenu = "mainMenu"
	

func _input(event):
	print("event: ", event)
	if global.state == "menuInput":
		if currentMenu == "mainMenu":
			currentArray = options
		elif currentMenu == "Inventory":
			currentArray = items
		
		if Input.is_action_just_pressed("ui_down"):
			currentOption += 1
			
			if currentOption >= currentArray.size():
				currentOption = 0
		
		if Input.is_action_just_pressed("ui_up"):
			currentOption -= 1
			
			if currentOption < 0:
				currentOption = currentArray.size() - 1
		
		if Input.is_action_just_pressed("ui_accept"):
			if !justOpened:
				var selectedOption = currentArray[currentOption].get_name()
				print("SelectedOption: ", selectedOption)
				if selectedOption == "Items":
					currentMenu = "Inventory"
					$Options.hide()
					$Inventory.show()
					$Inventory/ItemContainer.show()
				
				if selectedOption == "Close":
					selectedOption = "Items"
					global.state = "walking"
					self.hide()
					global.World.get_tree().paused = false
			
			if justOpened:
				justOpened = false
			
		if global.state == "menuInput" && Input.is_action_pressed("ui_cancel"):
			reset()
		
		updatePointer()
		
# Updates the position of the pointer
func updatePointer():
	var offSetForCentering = 30
	if currentMenu == "mainMenu":
		var position = Vector2(pointer.get_global_position().x, 
			options[currentOption].get_global_position().y + offSetForCentering)
		pointer.set_global_position(position)
	elif currentMenu == "Inventory":
		var position = Vector2(pointer.get_global_position().x, 
			items[currentOption].get_global_position().y + offSetForCentering)
		pointer.set_global_position(position)

# Gets all the items that the player carries
# and sets up the menu that will display these items	
func setInventoryOption():
	var itemArray = global.Player.inventory	
	for item in itemArray:
		var itemEntry = setLabels(item.name, item.count)
		#add entry to the ItemContainer
		$Inventory/ItemContainer.add_child(itemEntry)

	items = $Inventory/ItemContainer.get_children()

# Sets the labels values and returns a HBoxContainer
# that will be added to the VBoxContainer in the menu
func setLabels(itemName, itemCount):
	# create a labels for name and count	
	var itemLabel = ITEM_LABEL_SCENE.instance()
	var countLabel = ITEM_LABEL_SCENE.instance()

	itemLabel.itemText = itemName
	countLabel.itemText = "x" + str(itemCount)
	
	var horizontalContainer = HBoxContainer.new()
	horizontalContainer.add_child(itemLabel)
	horizontalContainer.add_child(countLabel)
	
	return horizontalContainer
	
func reset():
	currentMenu = "mainMenu"
	currentOption = 0
	$Options.visible = true
	$Inventory.visible = false
	global.UI.toggleMenu()
	global.state = "walking"

# Initializes the menu when opening it
func initMenu():
	$Options.visible = true
	$Inventory.visible = false
	currentMenu = "mainMenu"
