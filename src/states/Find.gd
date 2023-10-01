extends NavigationState

@export var miner: Miner
@export var mining_range: int = 100

var cart: Node2D

func enter(_msg := {}) -> void:
    navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
    navigation_agent.navigation_finished.connect(Callable(_on_navigation_finished))
    if _msg.has("cart"):
        cart = _msg.cart
        if !find_resources():
            state_machine.transition_to("Idle", {"target": cart})


func find_resources():
    var current_position = miner.global_position
    var resources = get_tree().get_nodes_in_group("resources")
    var nearest_resource: Node2D = null
    var nearest_resource_distance: float
    for _resource in resources:
        _resource = _resource as MiningResource
        var cart_distance: float = cart.global_position.distance_to(_resource.global_position)
        var distance: float = current_position.distance_to(_resource.global_position)
        if cart_distance <= mining_range and _resource.stats.resource_yield > 0:
            if nearest_resource == null:
                nearest_resource = _resource
                nearest_resource_distance = distance
            elif distance < nearest_resource_distance:
                nearest_resource = _resource
                nearest_resource_distance = distance
    if nearest_resource != null:
        set_movement_target(nearest_resource.global_position)
        return true
    return false