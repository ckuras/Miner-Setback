class_name Idle extends Navigation

func enter(_msg := {}):
	if _msg.has("target"):
		target = _msg.target
		randomize_wander()

func update(delta: float):
	pass

func randomize_wander():
	if target:
		await get_tree().create_timer(randf_range(1,3)).timeout
		target_position = (character.global_position + Vector2(randf_range(-50,50), randf_range(-50,50))) \
			.clamp(target.global_position + Vector2(-80, -80),target.global_position + Vector2(80, 80))
		set_movement_target(target_position, randf_range(10,20))
		await navigation_agent.navigation_finished
		randomize_wander()
