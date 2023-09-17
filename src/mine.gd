extends Node2D

@onready var mine_chunks = $mine_chunks
@onready var track: Path2D = $track
@onready var cart: PathFollow2D = $track/PathFollow2D
@onready var nav_region: NavigationRegion2D = $NavigationRegion2D

@onready var mine_chunk = preload("res://Scenes/mine_chunk.tscn")

const MINE_SIZE: int = 4
@onready var nav_timer: Timer = $Timer

func _ready():
	set_navigation_region()
	nav_timer.start()
	nav_timer.wait_time = .2
	nav_timer.timeout.connect(Callable(set_miner_nav))
	for i in MINE_SIZE:
		var mine_instance = mine_chunk.instantiate()
		mine_instance.position.y = (i + 1) * -160
		mine_chunks.add_child(mine_instance)
		track.curve.add_point(Vector2(0, i * -160))

func set_navigation_region():
	var polygon = NavigationPolygon.new()
	var vertices = PackedVector2Array([Vector2(-104, 80), Vector2(104, 80), Vector2(104, -160 * MINE_SIZE), Vector2(-104, -160 * MINE_SIZE)])
	polygon.vertices = vertices
	var indices = PackedInt32Array([0, 1, 2, 3])
	polygon.add_polygon(indices)
	nav_region.navigation_polygon = polygon

func set_miner_nav():
	get_tree().call_group("miner_units", "set_movement_target", cart.global_position)
