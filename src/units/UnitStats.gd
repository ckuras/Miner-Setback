class_name UnitStats extends Node

signal stats_updated(stats: UnitStats)

const BASE_STAT = 5

var type: String
var unit_name: String


var health: int
var max_health: int

@onready var constitution: int = BASE_STAT: set = set_constitution
@onready var move_speed: int = BASE_STAT
@onready var attack: int = BASE_STAT
@onready var haste: int = BASE_STAT


func initialize(stats: StartingUnitStats):
	type = stats.type
	generate_stats(stats.tier)

func generate_stats(tier: int):
	var bonus_stats: int = 0
	match tier:
		1:
			bonus_stats = 10
		2:
			bonus_stats = 12
		3:
			bonus_stats = 15
		_:
			#throw godot error
			pass
	distribute_bonus_stats(bonus_stats)
	

func distribute_bonus_stats(bonus_stats: int):
	var stats = ["constitution", "move_speed", "attack", "haste"]
	for n in range(1,bonus_stats + 1):
		var rand_stat = stats[randi() % stats.size()]
		set(rand_stat, get(rand_stat) + 1)
	print("Constitution: ",constitution)
	print("Move speed: ",move_speed)
	print("Attack: ",attack)
	print("Haste: ",haste)

func set_constitution(value: int):
	constitution = value
	max_health = constitution * 10
	health = max_health
	emit_signal("stats_updated", self)

func set_move_speed(value: int):
	move_speed = value
	emit_signal("stats_updated", self)

func set_attack(value: int):
	attack = value
	emit_signal("stats_updated", self)

func set_haste(value: int):
	haste = value
	emit_signal("stats_updated", self)
