class_name CartFollow extends Navigation

const FOLLOW_OFFSET: int = 20
var cart_speed: float

func enter(_msg := {}) -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	navigation_agent.navigation_finished.connect(Callable(_on_navigation_finished))
	if _msg.has("target"):
		target = _msg.target
	if _msg.has("cart_speed"):
		cart_speed = _msg.cart_speed
	follow_cart()

func exit() -> void:
	animation.play("RESET")
	navigation_agent.velocity_computed.disconnect(Callable(_on_velocity_computed))
	navigation_agent.navigation_finished.disconnect(Callable(_on_navigation_finished))

func follow_cart():
	if target and state_machine.state == self:
		target_position = target.global_position + Vector2(0, FOLLOW_OFFSET * cart_speed)
		set_movement_target(target_position, cart_speed * 100.0)
		await navigation_agent.navigation_finished
		follow_cart()
