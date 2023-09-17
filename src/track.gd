extends Path2D

@onready var main_cart = $PathFollow2D

var cart_speed: float = 1.0

var cart_moving: bool = false

func _process(_delta):
	if main_cart.progress_ratio == 1.0:
		cart_moving = false
	if cart_moving:
		main_cart.progress += cart_speed

func _unhandled_input(event):
	if event.is_action_pressed("stop") and cart_moving:
		cart_moving = false
	elif event.is_action_pressed("forward") and cart_moving:
		cart_moving = false
	elif event.is_action_pressed("reverse") and cart_moving:
		cart_moving = false
	elif event.is_action_pressed("forward") or event.is_action_pressed("stop") and !cart_moving:
		cart_moving = true
		cart_speed = 1.0
	elif event.is_action_pressed("reverse") and !cart_moving:
		cart_moving = true
		cart_speed = abs(cart_speed) * -1

