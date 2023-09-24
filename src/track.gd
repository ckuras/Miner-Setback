extends Path2D

@onready var main_cart = $PathFollow2D

var cart_speed: float = 0.8

var cart_moving: bool = false

enum States {IDLE, FOLLOW, FIND, MINE}

func _ready():
	main_cart.loop = false

func _process(_delta):
	if cart_moving:
		main_cart.progress += cart_speed
		get_tree().call_group("miner_units", "set_cart_position_and_speed", main_cart.global_position + Vector2(0, 20 * cart_speed), abs(cart_speed) * 100.0)
		get_tree().call_group("miner_units", "change_state", States.FOLLOW)
	else:
		get_tree().call_group("miner_units", "set_cart_position_and_speed", main_cart.global_position + Vector2(0, 20 * cart_speed), 0)
#		get_tree().call_group("miner_units", "find_resources", main_cart.global_position, 100)
	if main_cart.progress_ratio == 1.0 or main_cart.progress_ratio == 0.0 and cart_moving:
		cart_moving = false

func _unhandled_input(event):
	handle_movement_input(event)

func handle_movement_input(event):
	if event.is_action_pressed("stop") and cart_moving:
		cart_moving = false
	elif event.is_action_pressed("forward") and cart_moving:
		cart_moving = false
	elif event.is_action_pressed("reverse") and cart_moving:
		cart_moving = false
	elif event.is_action_pressed("forward") or event.is_action_pressed("stop") and !cart_moving:
		cart_moving = true
		cart_speed = 0.8
	elif event.is_action_pressed("reverse") and !cart_moving:
		cart_moving = true
		cart_speed = abs(cart_speed) * -1

