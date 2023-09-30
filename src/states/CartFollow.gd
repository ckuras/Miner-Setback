class_name CartFollow extends Navigation

const FOLLOW_OFFSET: int = 32
var cart_speed: float

func update(_delta: float) -> void:
	set_movement_target(target.global_position + Vector2(0, FOLLOW_OFFSET * cart_speed), cart_speed * 50.0)

func enter(_msg := {}) -> void:
	if _msg.has("target"):
		target = _msg.target
	if _msg.has("cart_speed"):
		cart_speed = _msg.cart_speed
