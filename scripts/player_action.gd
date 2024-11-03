extends CharacterBody3D

@onready var player = $"."
@onready var visuals = $visuals
@onready var animate_player = $visuals/playerv1/AnimationPlayer
@onready var camera_mount = $camera_mount
@onready var container = $InventoryWindow
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

@onready var camera = $camera_mount/Camera3D

var SPEED = 2.0
const JUMP_VELOCITY = 2.5

var walking_speed = 0.6
var running_speed = 3.0

var running = false
var is_locked = false
var drunk = false

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
	container.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	update_messages()

func _input(event):
	if event is InputEventMouseMotion:
		if !container.visible:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
			visuals.rotate_y(deg_to_rad(event.relative.x*sens_horizontal))

func _physics_process(delta: float):
	
	if Input.is_action_just_pressed("inventory"):
		container.visible = !container.visible
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if !animate_player.is_playing():
		is_locked = false
	
	if Input.is_action_just_pressed("kick"):
		if animate_player.current_animation != "fight":
			animate_player.play("fight")
			is_locked = true
	
	if Input.is_action_pressed("run") and !drunk:
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
				if animate_player.current_animation != "run" and !drunk:
					animate_player.play("run")
				if (drunk):
					animate_player.play("walk_drunk")
			else:
				if animate_player.current_animation != "walk_normal" and !drunk:
					animate_player.play("walk_normal")
				if (drunk):
					animate_player.play("walk_drunk")
		
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
 # Noir avec alpha
func _process(delta: float) -> void:
	if (drunk):
		shake_camera()
	for bar in progress_bar:
		bar.value -= 0.4
	set_dependecy()

	if Input.is_action_just_pressed("getItem"):    
		# Define the target position and range
		var target_position = Vector2(-5, -0)
		var range_target = 0.5
		# Check if the player is within 1 block of (10, 10)
		if abs(player.global_position.x - target_position.x) <= range_target and abs(player.global_position.y - target_position.y) <= range_target:
			container._addItem("poudre")
			container._addItem("cana")
			container._addItem("cig")
			container._addItem("cofee")
			container._addItem("bottle")


	

func _on_dealer_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://Dealer.tscn")

func _on_shop_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://Shop.tscn")

func set_dependecy() -> void:
	for bar in progress_bar:
		if bar.value <= 1500:
			drunk = true
			break
		else:
			drunk = false

var shake_strength = 0.01
var shake_duration = 0.01

func shake_camera():
	shake_strength += 0.00005
	var shake_offset = Vector3(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength), 0)
	camera.position += shake_offset
	await get_tree().create_timer(shake_duration).timeout
	camera.position -= shake_offset
