class_name Miner extends CharacterBody2D

signal toggle_inventory(external_inventory_owner)

@export var movement_speed: float = 80
@export var inventory_data: InventoryData
@export var mining_strength: int = 5
@export var mining_range: int = 100

@onready var state_machine: StateMachine = $StateMachine
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprites = $sprites
@onready var collision = $CollisionShape2D


func change_state(new_state: String, msg: Dictionary = {}) -> void:
	if state_machine.state != get_node(new_state):
		state_machine.transition_to(new_state, msg)

func _physics_process(_delta):
	set_sprite_direction()

func set_sprite_direction():
	var angle = global_position.angle_to_point(navigation_agent.target_position)
	if abs(angle) > PI/2:
		sprites.scale.x = 1
	else:
		sprites.scale.x = -1

func find_resources():
	var cart = get_tree().get_first_node_in_group('cart')
	var current_position = global_position
	var resources = get_tree().get_nodes_in_group("resources")
	var nearest_resource: Node2D = null
	var nearest_resource_distance: float
	for _resource in resources:
		_resource = _resource as MiningResource
		var cart_distance: float = cart.global_position.distance_to(_resource.global_position)
		var distance: float = current_position.distance_to(_resource.global_position)
		if cart_distance <= mining_range and _resource.stats.resource_yield > 0:
			if nearest_resource == null:
				nearest_resource = _resource
				nearest_resource_distance = distance
			elif distance < nearest_resource_distance:
				nearest_resource = _resource
				nearest_resource_distance = distance
	if nearest_resource != null:
		state_machine.transition_to("Navigation", {"target": nearest_resource})
		return true
	return false

func drop_off_resources(inventory: InventoryData):
	for index in range(0, inventory_data.slot_datas.size()):
		if inventory_data.slot_datas[index]:
			for i in range(0, inventory_data.slot_datas[index].quantity):
				if inventory_data.slot_datas[index]:
					var slot_data = inventory_data.slot_datas[index].create_single_slot_data()
					inventory.pick_up_slot_data(slot_data)
					inventory_data.inventory_updated.emit(inventory_data)
					await get_tree().create_timer(0.1).timeout
			inventory_data.slot_datas[index] = null
			inventory_data.inventory_updated.emit(inventory_data)


func inventory_interact() -> void:
	toggle_inventory.emit(self)
 

func _on_interact_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		inventory_interact()
