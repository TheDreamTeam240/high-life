extends Control

@onready var titleAnimation = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	titleAnimation.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_start_button_down() -> void:
	print("START BUTTON")
	get_tree().change_scene_to_file("res://main.tscn")

func _on_credit_pressed() -> void:
	print("CREDIT LOG")
	get_tree().change_scene_to_file("res://credit.tscn")
	
func _on_exit_pressed() -> void:
	print("EXIT GAME")
	get_tree().quit()
