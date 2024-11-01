extends Node

# Noise parameters
@export var frequency: float = 0.1
@export var seed: int = 42  # Random seed
@export var threshold_building: float = 0.2  # Noise threshold for building placement
@export var threshold_road: float = -0.1  # Noise threshold for road placement

# Constants for city generation
const NOISE_TYPE = FastNoiseLite.TYPE_CELLULAR
const CELLULAR_DISTANCE_FUNCTION = FastNoiseLite.DISTANCE_EUCLIDEAN
const CELLULAR_RETURN_TYPE = FastNoiseLite.RETURN_CELL_VALUE

@onready var building_A_model = preload("res://assets/KayKit_City_Builder_Bits_1.0_EXTRA/Assets/gltf/building_A.gltf")
@onready var park_base_model = preload("res://assets/KayKit_City_Builder_Bits_1.0_EXTRA/Assets/gltf/park_base.gltf")
@onready var road_straight_model = preload("res://assets/KayKit_City_Builder_Bits_1.0_EXTRA/Assets/gltf/road_straight.gltf")

var noise: FastNoiseLite

# Define city and block parameters
const CITY_SIZE = 100
const NOISE_SCALE = 0.1

func _ready():
	noise = FastNoiseLite.new()
	noise.set_noise_type(NOISE_TYPE)
	noise.set_frequency(frequency)
	noise.set_seed(seed)
	
	# Set cellular parameters
	noise.set_cellular_distance_function(CELLULAR_DISTANCE_FUNCTION)
	noise.set_cellular_return_type(CELLULAR_RETURN_TYPE)
	noise.set_cellular_jitter(0.5)  # Optional: Add some jitter to the cells
	
	create_ground()
	generate_city_map()

# Function to create a ground box
func create_ground():
	var ground_size = Vector3(CITY_SIZE, 0.5, CITY_SIZE)  # Size of the ground
	var static_body = StaticBody3D.new()
	
	var collision_shape_3d = CollisionShape3D.new()
	collision_shape_3d.shape = BoxShape3D.new()
	collision_shape_3d.shape.size = ground_size  # Set the size of the collision shape
	
	var mesh = MeshInstance3D.new()
	var boxmesh = BoxMesh.new()
	boxmesh.size = ground_size  # Set the size of the visual mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.5, 0.5, 0.5)  # Ground color

	boxmesh.material = material
	mesh.set_mesh(boxmesh)

	static_body.add_child(mesh)
	static_body.add_child(collision_shape_3d)
	
	# Position the ground slightly below the center
	static_body.position = Vector3(0, -0.05, 0)  # Adjust as necessary

	add_child(static_body)

func generate_city_map():
	var half_city_size = CITY_SIZE / 2
	var last_x = 0.0  # Variable to store the last x position
	var last_z = 0.0  # Variable to store the last z position
	
	for x in range(-half_city_size, half_city_size):
		for z in range(-half_city_size, half_city_size):
			var noise_value = noise.get_noise_2d(float(x) * NOISE_SCALE, float(z) * NOISE_SCALE)
			
			if noise_value > threshold_building:
				var position = create_building(Vector3(x, 0.5, z))
				last_x = position.x + 1
				last_z = position.z + 1
				
			elif noise_value > threshold_road:
				var position = create_road(Vector3(x, 0.5, z))
				last_x = position.x + 1 
				last_z = position.z + 1

			else:
				var position = create_park(Vector3(x, 0.5, z))
				last_x = position.x
				last_z = position.z

	# Optionally, you can print or store the last position after the generation process
	print("Last placed object position: ", last_x, last_z)

func create_building(position: Vector3) -> Vector3:
	var building_instance = building_A_model.instantiate()
	building_instance.global_position = position
	add_child(building_instance)
	return building_instance.global_position

func create_road(position: Vector3) -> Vector3:
	var road_instance = road_straight_model.instantiate()
	road_instance.global_position = position
	add_child(road_instance)
	return road_instance.global_position

func create_park(position: Vector3) -> Vector3:
	var park_instance = park_base_model.instantiate()
	park_instance.global_position = position
	add_child(park_instance)
	return park_instance.global_position
