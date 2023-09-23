class_name MiningResource extends Node2D

signal depleted

@export var starting_stats: Resource
@onready var stats: ResourceStats = $Stats

func _ready():
	stats.initialize(starting_stats)

func deplete_resource(amount):
	if stats.resource_yield > 0:
		stats.resource_yield -= amount
	else:
		emit_signal("depleted")


func _on_area_2d_body_entered(body):
	if body is Miner:
		print("in mining range ", body)
		var miner: Miner = body
		var current_miners: int = $Area2D.get_overlapping_bodies().size() - 1
		miner.mine_resource(self, current_miners)


func _on_area_2d_body_exited(body):if body is Miner:
		print("left mining range ", body)
		var miner: Miner = body
		miner.stop_mining()
