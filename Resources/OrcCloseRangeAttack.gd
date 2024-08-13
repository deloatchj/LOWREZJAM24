extends State

func enter() -> void:
	boss.attack_player()

func exit() -> void:
	pass

func process(_delta: float) -> void:
	state_machine.transition_to("Idle")
