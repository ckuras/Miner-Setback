class_name Idle extends NavigationState

func enter(_msg := {}):
    navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
    navigation_agent.navigation_finished.connect(Callable(_on_navigation_finished))
    if _msg.has("target"):
        target = _msg.target
    else:
        target = get_tree().get_first_node_in_group('cart')
    randomize_wander()


func randomize_wander():
    await get_tree().create_timer(randf_range(1,3)).timeout
    if target and state_machine.state == self:
        target_position = (character.global_position + Vector2(randf_range(-50,50), randf_range(-50,50))) \
            .clamp(target.global_position + Vector2(-80, -80),target.global_position + Vector2(80, 80))
        set_movement_target(target_position, randf_range(10,20))
        await navigation_agent.navigation_finished
        randomize_wander()

func _on_navigation_finished():
    animation.play("RESET")
