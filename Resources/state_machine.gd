extends Node

class_name StateMachine

var current_state = null
var states = {}

var boss = null

func _ready():
		boss = get_parent()
		
		for child in get_children():
				if child is State:
						states[child.name] = child
						child.state_machine = self
						child.boss = boss

func start(initial_state = null):
		if initial_state == null:
				initial_state = get_child(0).name
		transition_to(initial_state)

func transition_to(state_name):
		if current_state != null:
				current_state.exit()
		current_state = states[state_name]
		current_state.enter()

func process(delta):
		if current_state != null:
				current_state.process(delta)
