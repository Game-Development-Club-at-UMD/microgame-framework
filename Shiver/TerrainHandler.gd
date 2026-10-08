extends StaticBody3D

@onready var map: CollisionShape3D = $Map
@onready var mesh := $MeshInstance3D
var height_noise: FastNoiseLite
var height_map: PackedFloat64Array

@export var frequency : float = 0.03
@export var map_size : int = 512
@export var valley_value : float = -5.0
@export var peak_value : float = 5.0

@export var game: MicroGame

# Called by the game so that objects can be spawned afterwards.
func start() -> void:
	_init_noise()
	_generate_height_map()
	var image:= create_image()
	
	# adjust peak value by fetching from difficulty
	peak_value = game.difficulty * 20
	frequency = 0.03
	
	# adjust mesh size to match the map's
	var plane_mesh : PlaneMesh = mesh.mesh
	plane_mesh.set_size(Vector2(map_size,map_size))
	plane_mesh.subdivide_depth = map_size # match resolution
	plane_mesh.subdivide_width = map_size # match resolution
	
	var shader_material : ShaderMaterial = plane_mesh.material
	shader_material.set_shader_parameter("noise",ImageTexture.create_from_image(image))
	shader_material.set_shader_parameter("height_mult",valley_value * -1 + peak_value)
	map.shape.update_map_data_from_image(image, valley_value, peak_value)
	mesh.position.y = valley_value #adjust position based on lower value
	


func _init_noise() -> void:
	height_noise = FastNoiseLite.new()
	height_noise.seed = randi()
	height_noise.frequency = frequency

func _generate_height_map() -> void:
	for y in map_size:
		for x in map_size:
			var value: float = height_noise.get_noise_2d(x,y)
			height_map.append(value)

func create_image() -> Image:
	var image:= Image.new()
	@warning_ignore("static_called_on_instance")
	image.create(map_size,map_size,false,Image.FORMAT_RGB8)
	
	var buffer := PackedByteArray()
	buffer.resize(map_size * map_size * 3)
	buffer = image.get_data()
	
	for y in map_size:
		for x in map_size:
			var grayscale_value = int((height_map[y * map_size + x] + 1) * 127.5)
			
			buffer.append(grayscale_value) # Red
			buffer.append(grayscale_value) # Green
			buffer.append(grayscale_value) # Blue
	
	
	image.set_data(map_size,map_size, false, Image.FORMAT_RGB8, buffer)
	image.convert(Image.FORMAT_RF)
	return image
	
