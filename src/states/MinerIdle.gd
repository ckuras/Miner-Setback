extends Idle

@onready var miner: Miner = character

func enter(_msg := {}):
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	navigation_agent.navigation_finished.connect(Callable(_on_navigation_finished))
	if _msg.has("target"):
		target = _msg.target
	else:
		target = get_tree().get_first_node_in_group('cart')
	idle_transitions()

func idle_transitions():
	if !miner.inventory_data.is_empty():
		state_machine.transition_to("FindCart", { "target": get_tree().get_first_node_in_group('cart')})
		return
	if !miner.find_resources():
		randomize_wander()
	return
