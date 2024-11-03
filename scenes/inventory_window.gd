extends Panel

@onready var poudrenbr = $SlotContainer/Slot1/Number
@onready var cananbr = $SlotContainer/Slot2/Number
@onready var bottlenbr = $SlotContainer/Slot3/Number
@onready var cignbr = $SlotContainer/Slot4/Number
@onready var cofeenbr = $SlotContainer/Slot5/Number

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _addItem(Item):
	if Item == "poudre":
		_setNumber(poudrenbr, 1)
		print("Poudre:", _getNumber(poudrenbr))
	if Item == "cana":
		_setNumber(cananbr, 1)
		print("Cana:", _getNumber(cananbr))
	if Item == "bottle":
		_setNumber(bottlenbr, 1)
		print("Bottle:", _getNumber(bottlenbr))
	if Item == "cig":
		_setNumber(cignbr, 1)
		print("Cigarette:", _getNumber(cignbr))
	if Item == "cofee":
		_setNumber(cofeenbr, 1)
		print("Poudre:", _getNumber(cofeenbr))
		
#func _removeItem():
	
	

func _getNumber(Slot) -> String:
	return Slot.text

func _setNumber(Slot, operation):
	if Slot.text == str(0) and operation == 0:
		return
	if operation == 1:
		Slot.text = str(int(Slot.text) + 1)
	else:
		Slot.text = str(int(Slot.text) - 1)
