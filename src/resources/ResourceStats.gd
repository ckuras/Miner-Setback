class_name ResourceStats extends Node

signal depleted

var resource_yield: int

var resource_strength: int
var resource_health: int

var min_yield: int
var max_yield: int

func initialize(stats: StartingResourceStats):
	resource_strength = stats.resource_strength
	resource_health = stats.resource_health
	min_yield = stats.min_yield
	max_yield = stats.max_yield
	resource_yield = get_yield()

func get_yield():
	randomize()
	return randi_range(min_yield, max_yield)
