extends NavigationState

@export var miner: Miner
@export var mining_range: int = 100

var cart: Node2D

func enter(_msg := {}) -> void:
    navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
    navigation_agent.navigation_finished.connect(Callable(_on_navigation_finished))
    if _msg.has("cart"):
        cart = _msg.cart
    else:
        cart = get_tree().get_first_node_in_group('cart')
    if !miner.find_resources():
        state_machine.transition_to("Idle", {"target": cart})
