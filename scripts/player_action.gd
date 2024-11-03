extends CharacterBody3D

@onready var visuals = $visuals
@onready var animate_player = $visuals/playerv1/AnimationPlayer
@onready var camera_mount = $camera_mount
@onready var rich_text_labels: Array = [
	$"Dependency bar/RichTextLabel",
	$"Dependency bar2/RichTextLabel",
	$"Dependency bar3/RichTextLabel",
	$"Dependency bar4/RichTextLabel",
	$"Dependency bar5/RichTextLabel"
]

@onready var progress_bar: Array = [
	$"Dependency bar/TextureProgressBar",
	$"Dependency bar2/TextureProgressBar",
	$"Dependency bar3/TextureProgressBar",
	$"Dependency bar4/TextureProgressBar",
	$"Dependency bar5/TextureProgressBar"
]

var SPEED = 2.0
const JUMP_VELOCITY = 2.5

var walking_speed = 0.6
var running_speed = 3.0

var running = false
var is_locked = false

var messages: Array = [
	"Café",
	"Alcool",
	"Cigarette",
	"Zamal",
	"Cocaine"
]
var current_index: int = 0 

@export var sens_horizontal = 0.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	update_messages()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))

func _physics_process(delta: float):
	if !animate_player.is_playing():
		is_locked = false
	
	if Input.is_action_just_pressed("kick"):
		if animate_player.current_animation != "fight":
			animate_player.play("fight")
			is_locked = true
	
	if Input.is_action_pressed("run"):
		SPEED = running_speed
		running = true
	else:
		SPEED = walking_speed
		running = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("right", "left", "back", "forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !is_locked:
			if running:
				if animate_player.current_animation != "run":
					animate_player.play("run")
			else:
				if animate_player.current_animation != "walk_normal":
					animate_player.play("walk_normal")
		
			visuals.look_at(position + direction * -1)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !is_locked:
			if animate_player.current_animation != "idle":
				animate_player.play("idle")
		velocity.x = move_toward(-velocity.x, 0, SPEED)
		velocity.z = move_toward(-velocity.z, 0, SPEED)
	
	if !is_locked:
		move_and_slide()

func _on_child_added(_child: Node) -> void:
	update_messages()

func update_messages() -> void:
	if current_index < messages.size():
		for label in rich_text_labels:
			label.add_text(messages[current_index] + "\n")
			current_index += 1

func _process(delta: float) -> void:
	for bar in progress_bar:
		bar.value -= 0.4

func _on_dealer_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://Dealer.tscn")

func _on_shop_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://Shop.tscn")
