extends Control

# Référence au RichTextLabel dans l'inspecteur
@onready var rich_text_label: RichTextLabel = $RichTextLabel

# Liste de messages à afficher
var messages: Array = [
	"Bienvenue dans notre scène !",
	"Une nouvelle dépendance a été ajoutée.",
	"Votre projet prend forme !",
	"Chaque ajout compte, continuez !",
	"C'est un excellent début, continuez à ajouter !"
]

# Variable pour garder une trace des messages déjà affichés
var displayed_indices: Array = []

# Appelé lorsque le nœud entre dans l'arbre de scène pour la première fois.
func _ready() -> void:
	# Vérifier si le nœud a des enfants au démarrage
	for child in get_children():
		_on_child_added(child)

# Appelé chaque fois qu'un enfant est ajouté
func _on_child_added(child: Node) -> void:
	var index = randi() % messages.size()
	
	# S'assurer de ne pas afficher le même message plusieurs fois
	while index in displayed_indices:
		index = randi() % messages.size()
	
	displayed_indices.append(index)

	# Ajouter le message au RichTextLabel
	rich_text_label.append_bbcode("[color=white]" + messages[index] + "[/color]\n")

# Appelé chaque frame. 'delta' est le temps écoulé depuis la frame précédente.
func _process(delta: float) -> void:
	pass
