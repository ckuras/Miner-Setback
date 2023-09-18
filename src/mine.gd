extends Node2D

@onready var mine_chunks = $mine_chunks
@onready var track: Path2D = $track

@onready var mine_chunk = preload("res://Scenes/Mine Chunks/mine_chunk.tscn")

const MINE_SIZE: int = 4

func _ready():
	for i in MINE_SIZE:
		var mine_instance = mine_chunk.instantiate()
		mine_instance.position.y = (i + 1) * -160
		mine_chunks.add_child(mine_instance)
		track.curve.add_point(Vector2(0, i * -160))


