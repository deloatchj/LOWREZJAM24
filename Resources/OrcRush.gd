extends State

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(delta: float) -> void:
	if boss.player:
		var direction: Vector3 = (boss.player.global_transform.origin - boss.global_transform.origin).normalized()
		boss.velocity = direction * boss.speed * boss.rush_speed_multiplier
		boss.move_and_slide()

		if boss.global_transform.origin.distance_to(boss.player.global_transform.origin) <= boss.close_range_attack_distance:
			boss.attack_player()
			var push_direction: Vector3 = boss.global_transform.origin - boss.player.global_transform.origin
			boss.global_transform.origin += push_direction.normalized() * 5.0
			state_machine.transition_to("Idle")
