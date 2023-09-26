extends Node2D

@onready var cart: CharacterBody2D = $track/PathFollow2D/cart
@onready var inventory_interface = $UI/InventoryInterface

@onready var mine_chunks = $mine_chunks
@onready var starting_chunk = $mine_chunks/mine_chunk_start
@onready var resources = $resources
@onready var track: Path2D = $track

@onready var mine_chunk = preload("res://Scenes/Mine Chunks/mine_chunk.tscn")

const MINE_SIZE: int = 4

func _ready() -> void:
	starting_chunk.initialize_resources(resources)
	for i in MINE_SIZE:
		var mine_instance: MineChunk = mine_chunk.instantiate()
		mine_instance.position.y = (i + 1) * -160
		mine_chunks.add_child(mine_instance)
		mine_instance.initialize_resources(resources)
		track.curve.add_point(Vector2(0, i * -160))
	cart.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_cart_inventory_data(cart.inventory_data)
	
	for node in get_tree().get_nodes_in_group("miner_units"):
		node.toggle_inventory.connect(toggle_inventory_interface)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
#	if inventory_interface.visible:
#		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#	else:
#		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()
