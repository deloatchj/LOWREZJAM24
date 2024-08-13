extends State

@export var scream_distance: float = 10.0
@export var scream_slow_duration: float = 1.0
@export var scream_slow_factor: float = 0.5
@export var minion_scene: PackedScene

func enter() -> void:
	perform_scream()

func exit() -> void:
	pass

func process(_delta: float) -> void:
	state_machine.transition_to("IdleState")

func perform_scream() -> void:
	if boss.player:
		var distance_to_player: float = boss.global_transform.origin.distance_to(boss.player.global_transform.origin)
		if distance_to_player >= scream_distance:
			slow_down_player()
			spawn_minions()

func slow_down_player() -> void:
	if boss.player:
		boss.player.speed *= scream_slow_factor
		await get_tree().create_timer(scream_slow_duration).timeout
		boss.player.speed /= scream_slow_factor

func spawn_minions() -> void:
	var minion: Node3D = minion_scene.instantiate()
	boss.add_child(minion)
