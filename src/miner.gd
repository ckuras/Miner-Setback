extends CharacterBody2D

@export var movement_speed: float = 80

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var movement_delta: float

func _ready():
	navigation_agent.path_desired_distance = 20.0
	navigation_agent.target_desired_distance = 15.0
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(target_point: Vector2):
	await get_tree().create_timer(.2).timeout
	navigation_agent.target_position = target_point

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
	movement_delta = movement_speed * delta
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector2 = global_position
	var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * movement_delta
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)

func _on_navigation_agent_2d_target_reached():
	pass
#	print('target reached')

