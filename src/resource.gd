class_name MiningResource extends Node2D

signal mined(miner: Miner, item: ItemData)

@export var starting_stats: Resource

@onready var stats: ResourceStats = $Stats
@onready var sprite: Sprite2D = $Sprite

var depleted: bool = false

func _ready():
	stats.initialize(starting_stats)
	stats.depleted.connect(Callable(self, "_on_depleted"))
	_set_sprite()

func _on_depleted():
	pass

func _set_sprite():
	randomize()
	sprite.region_rect = Rect2i(Vector2i((randi_range(0,2) * 17),(randi_range(0,2) * 17)), Vector2i(16,16))

#func gather_resource(amount):
#	if stats.resource_yield > 0:
#		stats.resource_yield -= amount
#	else:
#		emit_signal("depleted")

func mine_resource(miner: Miner):
	if miner.mining_strength >= stats.resource_strength \
		and stats.resource_yield > 0:
		if stats.current_resource_health <= 0:
			emit_signal("mined", miner, stats.item)
			stats.resource_yield -= 1
			stats.current_resource_health = stats.max_resource_health
		else:
			stats.current_resource_health -= miner.mining_strength
			print("resource health: ", stats.current_resource_health)
			emit_signal("mined", miner, null)
	else:
		miner.stop_mining(self)

func _on_area_2d_body_entered(body):
	if body is Miner:
		print("in mining range ", body)
		var miner: Miner = body
		var current_miners: int = $Area2D.get_overlapping_bodies().size() - 1
		miner.mine_resource(self, current_miners)


func _on_area_2d_body_exited(body):
	if body is Miner:
		print("left mining range ", body)
		var miner: Miner = body
		miner.stop_mining(self)
