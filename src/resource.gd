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
		miner.mine_resource(self)


func _on_area_2d_body_exited(body):if body is Miner:
		print("in mining range ", body)
		var miner: Miner = body
		miner.navigation_agent.radius = 6
