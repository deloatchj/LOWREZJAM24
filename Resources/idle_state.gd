extends State

var idle_duration = 2.0

func enter():
		%Anim.play("walk")
		$Timer.start(idle_duration)

func exit():
		$Timer.stop()

func process(delta):
		if boss.player_distance() > 10:
				state_machine.transition_to("Chase")
		elif boss.player_distance() > 20:
				state_machine.transition_to("Spin")

func _on_Timer_timeout():
		if randf() < 0.5:
				state_machine.transition_to("Chase")
		else:
				state_machine.transition_to("Spin")
