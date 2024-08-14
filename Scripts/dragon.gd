extends CharacterBody3D

@export var total_hp = 20
@export var crystals_destroyed = 0
@export var hover_speed = 2
@export var cooldown_reduction = 0.0
@export var teeth_scene : PackedScene
@export var patrol_radius = 10
@export var patrol_center = Vector3(0, 6, -13)
@export var patrol_speed = 0.5 

var current_state = "patrol"
var can_damage = false
var hp = 20
var player = null
var patrol_angle = 0.0 

func _ready():
	position = patrol_center + Vector3(0, 0, -patrol_radius) 
	set_physics_process(false)
	patrol()

func _process(delta):
	match current_state:
		"patrol":
			patrol_movement(delta)
		"full_field":
			full_field_attack()
		"focus":
			focus_attack()
		"nudge":
			nudge_player()

func patrol():
	current_state = "patrol"
	set_physics_process(true)
	patrol_movement(0)

func patrol_movement(delta):
	patrol_angle += patrol_speed * delta 
	var x = patrol_center.x + patrol_radius * sin(patrol_angle)
	var z = patrol_center.z + patrol_radius * cos(patrol_angle)
	position = Vector3(x, patrol_center.y, z)
	if int(patrol_angle) % int(TAU) == 0:
		%Hurtsfx.play()

func roar():
	%Roar.play()
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_process(false)
		player.set_physics_process(false)
		await get_tree().create_timer(2)

func full_field_attack():
	current_state = "full_field"
	pass

func focus_attack():
	current_state = "focus"
	pass

func nudge_player():
	current_state = "nudge"
	# Land near the player and apply impulse
	pass

func crystal_destroyed():
	crystals_destroyed += 1
	hp -= 2
	if crystals_destroyed % 2 == 0:
		cooldown_reduction += 0.2
		hover_speed = min(hover_speed + 2, 6)

	if crystals_destroyed == 6:
		make_vulnerable()

func make_vulnerable():
	can_damage = true

func on_damage(damage):
	if crystals_destroyed == 6:
		hp -= damage
		if hp <= 8:
			drop_teeth()
			if hp <= 0:
				die()

func drop_teeth():
	var teeth = teeth_scene.instantiate()
	teeth.transform.origin = Vector3(0,1.1,0)
	teeth.scale = Vector3(5,5,5)
	get_parent().add_child(teeth)
	pass

func die():
	velocity.y -= 1

func minus_hp(dmg):
	if can_damage:
		if hp < 1:
			die()
		else:
			drop_teeth()
			var dmg_tween = get_tree().create_tween()
			dmg_tween.tween_property(%Anim, "modulate", Color(1, 0, 0, 1), 0.2)
			dmg_tween.tween_property(%Anim, "modulate", Color(1, 1, 1, 1), 0.2)
			%Hurtsfx.play()
			hp -= dmg
