class_name ResourceStats extends Node

signal depleted

var resource_name: String
var item: ItemData

var resource_yield: int
var min_yield: int
var max_yield: int

var resource_strength: int
var max_resource_health: int
var current_resource_health


func initialize(stats: StartingResourceStats):
	resource_name = stats.name
	item = stats.item
	resource_strength = stats.resource_strength
	max_resource_health = stats.max_resource_health
	current_resource_health = max_resource_health
	min_yield = stats.min_yield
	max_yield = stats.max_yield
	resource_yield = get_yield()

func get_yield():
	randomize()
	return randi_range(min_yield, max_yield)
