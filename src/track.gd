extends Path2D

@onready var main_cart = $PathFollow2D

var cart_speed: float = 0.8

var cart_moving: bool = false

@export var nav_timer: Timer

func _ready():
	main_cart.loop = false
	nav_timer.timeout.connect(Callable(set_miner_nav))
	nav_timer.start()
	nav_timer.wait_time = .2

func _process(_delta):
	if cart_moving:
		main_cart.progress += cart_speed
	if main_cart.progress_ratio == 1.0 or main_cart.progress_ratio == 0.0 and cart_moving:
		cart_moving = false
	set_miner_nav()

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
		cart_speed = 1.0
	elif event.is_action_pressed("reverse") and !cart_moving:
		cart_moving = true
		cart_speed = abs(cart_speed) * -1

func set_miner_nav():
	if cart_moving:
		get_tree().call_group("miner_units", "set_movement_target", main_cart.global_position)
	else:
		get_tree().call_group("miner_units", "find_resources", main_cart.global_position, 100)
