extends State

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(delta: float) -> void:
	if boss.player:
		var distance_to_player: float = boss.global_transform.origin.distance_to(boss.player.global_transform.origin)
		if distance_to_player <= boss.close_range_attack_distance:
			state_machine.transition_to("CloseRangeAttack")
		elif distance_to_player >= boss.scream_distance:
			state_machine.transition_to("ScreamState")
		else:
			state_machine.transition_to("Rush")
