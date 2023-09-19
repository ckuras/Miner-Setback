class_name Miner extends CharacterBody2D

@export var movement_speed: float = 80
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

const AVOIDANCE_RADIUS: int = 6

func _ready():
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(target_point: Vector2):
	await get_tree().create_timer(.2).timeout
	navigation_agent.target_position = target_point

func _physics_process(_delta):
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
	velocity = safe_velocity
	move_and_slide()

func _on_navigation_agent_2d_target_reached():
	pass
#	print('target reached')

func mine_resource(resource: MiningResource, current_miners: int):
	if (current_miners > 4):
		get_tree().call_group("miner_units", "set_navigation_avoidance_radius", 4)
	if (current_miners > 8):
		get_tree().call_group("miner_units", "set_navigation_avoidance_radius", 2)
	print('start mining ', resource)

func stop_mining():
	navigation_agent.radius = AVOIDANCE_RADIUS

func set_navigation_avoidance_radius(radius: int):
	navigation_agent.radius = radius
	
