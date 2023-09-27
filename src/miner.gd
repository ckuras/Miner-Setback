class_name Miner extends CharacterBody2D

signal toggle_inventory(external_inventory_owner)
signal strike_resource(miner: Miner)

@export var movement_speed: float = 80
@export var inventory_data: InventoryData
@export var mining_strength: int = 5

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprites = $sprites
@onready var collision = $CollisionShape2D

const AVOIDANCE_RADIUS: int = 6

var cart_position: Vector2 = Vector2(0, 64)
var cart_speed: float

enum States {IDLE, FOLLOW, FIND, MINE}

var _state : int = States.IDLE

func _ready():
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	animation.animation_finished.connect(on_animation_finished)

func change_state(new_state: int) -> void:
	var previous_state := _state
	_state = new_state
	
	match _state:
		States.IDLE:
			animation.play("RESET")
		States.FOLLOW:
			animation.play("walk")
		States.FIND:
			animation.play("walk")
		States.MINE:
			animation.play("mine")

func set_movement_target(target_point: Vector2, speed: float = 80):
	movement_speed = speed
	navigation_agent.target_position = target_point

func _physics_process(_delta):
	match _state:
		States.IDLE:
			if find_resources(cart_position, 100):
				change_state(States.FIND)
		States.FOLLOW:
			if cart_speed != 0:
				follow_cart()
			else:
				change_state(States.IDLE)
		States.FIND:
			find_resources(cart_position, 100)
		States.MINE:
			pass
	set_sprite_direction()
	navigate()

func set_sprite_direction():
	var angle = global_position.angle_to_point(navigation_agent.target_position)
	if abs(angle) > PI/2:
		sprites.scale.x = 1
	else:
		sprites.scale.x = -1

func navigate():
	if navigation_agent.is_navigation_finished():
		return
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector2 = global_position
	var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if _state != States.IDLE or _state != States.MINE:
		velocity = safe_velocity
		move_and_slide()

func follow_cart():
	set_movement_target(cart_position, cart_speed)

func find_resources(cart_pos: Vector2, mining_range: int):
	var current_position = global_position
	var resources = get_tree().get_nodes_in_group("resources")
	var nearest_resource: Node2D = null
	var nearest_resource_distance: float
	for _resource in resources:
		_resource = _resource as Node2D
		var cart_distance: float = cart_pos.distance_to(_resource.global_position)
		var distance: float = current_position.distance_to(_resource.global_position)
		if cart_distance <= mining_range:
			if nearest_resource == null:
				nearest_resource = _resource
				nearest_resource_distance = distance
			elif distance < nearest_resource_distance:
				nearest_resource = _resource
				nearest_resource_distance = distance
	if nearest_resource != null:
		set_movement_target(nearest_resource.global_position)
		return true
	return false

func mine_resource(resource: MiningResource, current_miners: int):
	connect_mining_signals(resource)
	change_state(States.MINE)
	if (current_miners > 4):
		get_tree().call_group("miner_units", "set_navigation_avoidance_radius", 4)
	if (current_miners > 8):
		get_tree().call_group("miner_units", "set_navigation_avoidance_radius", 2)
	print('start mining ', resource)

func on_resource_mined(item: ItemData):
#	print("on resource mined")
	if item:
		var slot_instance: SlotData = SlotData.new()
		slot_instance.item_data = item
		if not inventory_data.pick_up_slot_data(slot_instance):
			print('inventory full')
			change_state(States.IDLE)
	animation.play("mine")

func stop_mining(resource: MiningResource):
	disconnect_mining_signals(resource)
	navigation_agent.radius = AVOIDANCE_RADIUS
	change_state(States.IDLE)

func connect_mining_signals(resource: MiningResource):
	resource.mined.connect(on_resource_mined)
	strike_resource.connect(resource.mine_resource)

func disconnect_mining_signals(resource: MiningResource):
	resource.mined.disconnect(on_resource_mined)
	strike_resource.disconnect(resource.mine_resource)

func set_navigation_avoidance_radius(radius: int):
	navigation_agent.radius = radius
	
func set_cart_position_and_speed(_cart_position, _cart_speed):
	cart_position = _cart_position
	cart_speed = _cart_speed

func on_animation_finished(animation_name: String):
	if animation_name == "mine":
		emit_signal("strike_resource", self)

func inventory_interact() -> void:
	toggle_inventory.emit(self)


func _on_interact_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		inventory_interact()
