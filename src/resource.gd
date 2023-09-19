class_name MiningResource extends Node2D

signal depleted

var resource_yield: int = 100

func deplete_resource(amount):
	if resource_yield > 0:
		resource_yield -= amount
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
