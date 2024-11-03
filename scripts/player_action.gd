extends CharacterBody3D
@onready var visuals = $visuals
@onready var animate_player =$visuals/playerv1/AnimationPlayer
@onready var camera_mount =$camera_mount

var SPEED = 2.0
const JUMP_VELOCITY = 4.5

var walking_speed = 0.6
var running_speed = 3.0

var running = false
var is_locked = false

@export var sens_horizontal = 0.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x*sens_horizontal))


func _physics_process(delta: float):
	
	if !animate_player.is_playing():
		is_locked =  false
	
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
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	 
			visuals.look_at(position + direction *-1)
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

func _on_dealer_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://Dealer.tscn")

func _on_shop_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://Shop.tscn")
