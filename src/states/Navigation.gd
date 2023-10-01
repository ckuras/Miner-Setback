class_name NavigationState extends State


@export var character: CharacterBody2D
@export var navigation_agent: NavigationAgent2D

var target: Node2D
var target_position: Vector2
var movement_speed: float = 80.0

func physics_update(_delta: float) -> void:
    navigate()

func enter(_msg := {}) -> void:
    if _msg.has("target"):
        target = _msg.target
    navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
    navigation_agent.navigation_finished.connect(Callable(_on_navigation_finished))

func exit() -> void:
    target = null
    animation.play("RESET")
    navigation_agent.velocity_computed.disconnect(Callable(_on_velocity_computed))
    navigation_agent.navigation_finished.disconnect(Callable(_on_navigation_finished))

func set_movement_target(target_point: Vector2, speed: float = 80):
    movement_speed = abs(speed)
    navigation_agent.target_position = target_point

func navigate():
    if navigation_agent.is_navigation_finished():
        return
    if animation.assigned_animation != "walk":
        animation.play("walk")
    var next_path_position: Vector2 = navigation_agent.get_next_path_position()
    var current_agent_position: Vector2 = character.global_position
    var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * movement_speed
    if navigation_agent.avoidance_enabled:
        navigation_agent.set_velocity(new_velocity)
    else:
        _on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
    character.velocity = safe_velocity
    character.move_and_slide()

func _on_navigation_finished():
    pass
