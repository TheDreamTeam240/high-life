extends Button  # Assurez-vous que ce script est attaché à un nœud de type Button

# Variable pour stocker la valeur de Number
@onready var nbr = $Number

@onready var inventory = $"../../"

var is_clik = false
func _ready() -> void:
	# Connecte le signal `pressed()` du bouton en utilisant Callable
	self.connect("pressed", Callable(self, "_on_button_pressed"))
	
func _process(delta: float) -> void:
	if is_clik:
		inventory._setNumber(nbr, 0)
		is_clik = false

func _on_button_pressed() -> void:
	# Diminue la valeur de Number de 1
	is_clik = true
	
