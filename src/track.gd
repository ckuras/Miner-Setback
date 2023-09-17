extends Path2D

@onready var main_cart = $PathFollow2D

const CART_SPEED = 0.2

func _process(_delta):
	main_cart.progress += CART_SPEED
