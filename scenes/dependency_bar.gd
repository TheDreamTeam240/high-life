extends Control

@onready var rich_text_label: RichTextLabel = $RichTextLabel

var messages: Array = [
	"Café",
	"Codéine",
	"Test",
	"Test2",
	"Test3"
]
var current_index: int = 0  # Déclaration comme variable d'instance

func _ready() -> void:    
	# Met à jour les messages au démarrage
	update_messages()

# Appelé chaque fois qu'un enfant est ajouté
func _on_child_added(_child: Node) -> void:
	update_messages()

# Met à jour le RichTextLabel avec le message suivant
func update_messages() -> void:
	if current_index < messages.size():  # Vérifie s'il y a encore des messages à afficher
		rich_text_label.add_text(messages[current_index] + "\n")  # Ajouter le message au RichTextLabel
		current_index += 1  # Incrémente l'index pour le prochain message

func _process(_delta: float) -> void:
	pass
