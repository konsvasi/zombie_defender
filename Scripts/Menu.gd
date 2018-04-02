extends Polygon2D

const ITEM_LABEL_SCENE = preload("res://Scenes/ItemLabel.tscn")

var currentOption = 0
var options
var pointer
var justOpened


func _ready():
	justOpened = true
	options = $Options.get_children()
	pointer = $Pointer
	updatePointer()
	setInventoryOption()

func _input(event):
	if Input.is_action_pressed("ui_down"):
		currentOption += 1
		
		if currentOption >= options.size():
			currentOption = 0
	
	if Input.is_action_pressed("ui_up"):
		currentOption -= 1
		
		if currentOption < 0:
			currentOption = options.size() - 1
	
	if Input.is_action_just_pressed("ui_accept"):
		if !justOpened:
			var selectedOption = options[currentOption].get_name()
			
			if selectedOption == "Items":
				$Options.hide()
				$Inventory.show()
		
		if justOpened:
			justOpened = false
		
	if Input.is_action_pressed("ui_cancel"):
		global.UI.toggleMenu()
	
	updatePointer()
		
# Updates the poisition of the pointer
func updatePointer():
	var offSetForCentering = 30
	var position = Vector2(pointer.get_global_position().x, 
		options[currentOption].get_global_position().y + offSetForCentering)
	pointer.set_global_position(position)

# Gets all the items that the player carries
# and sets up the menu that will display these items	
func setInventoryOption():
	var itemArray = global.Player.inventory
	
	for item in itemArray:
		var itemEntry = setLabels(item.name, item.count)
		
		$Inventory/ItemContainer.add_child(itemEntry)
		# add child to this label for the count
		# add the parent label to inventory node

# Sets the labels values and returns a HBoxContainer
# that will be added to the VBoxContainer in the menu
func setLabels(itemName, itemCount):
	# create a labels for name and count	
	var itemLabel = ITEM_LABEL_SCENE.instance()
	var countLabel = ITEM_LABEL_SCENE.instance()
	
	#setStyles(itemLabel, itemCount)
	itemLabel.itemText = itemName
	countLabel.itemText = "x" + str(itemCount)
	
	var horizontalContainer = HBoxContainer.new()
	horizontalContainer.add_child(itemLabel)
	horizontalContainer.add_child(countLabel)
	
	return horizontalContainer
