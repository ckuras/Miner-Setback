extends Node2D

@onready var mine_chunks = $mine_chunks
@onready var starting_chunk = $mine_chunks/mine_chunk_start
@onready var resources = $resources
@onready var track: Path2D = $track

@onready var mine_chunk = preload("res://Scenes/Mine Chunks/mine_chunk.tscn")

const MINE_SIZE: int = 4

func _ready():
	starting_chunk.initialize_resources(resources)
	for i in MINE_SIZE:
		var mine_instance: MineChunk = mine_chunk.instantiate()
		mine_instance.position.y = (i + 1) * -160
		mine_chunks.add_child(mine_instance)
		mine_instance.initialize_resources(resources)
		track.curve.add_point(Vector2(0, i * -160))


