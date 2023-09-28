extends Path2D

@onready var cart_progress = $PathFollow2D
@onready var cart = $PathFollow2D/cart

var cart_speed: float = 0.8

var cart_moving: bool = false

enum States {IDLE, DROP_OFF, FOLLOW, FIND, MINE}

func _ready():
	cart_progress.loop = false

func _process(_delta):
	if cart_moving:
		cart_progress.progress += cart_speed
		cart.animation_player.play("move")
		cart.navigation_obstacle.velocity = Vector2(0, cart_speed)
		get_tree().call_group("miner_units", "set_cart_position_and_speed", cart_progress.global_position, cart_speed * 100.0)
		get_tree().call_group("miner_units", "change_state", States.FOLLOW)
	else:
		cart.animation_player.play("RESET")
		get_tree().call_group("miner_units", "set_cart_position_and_speed", cart_progress.global_position, 0)
#		get_tree().call_group("miner_units", "find_resources", cart_progress.global_position, 100)
	if cart_progress.progress_ratio == 1.0 or cart_progress.progress_ratio == 0.0 and cart_moving:
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

