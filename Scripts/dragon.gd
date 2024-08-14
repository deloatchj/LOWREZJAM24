extends CharacterBody3D

@export var total_hp = 20
@export var crystals_destroyed = 0
@export var hover_speed = 2
@export var cooldown_reduction = 0.0
@export var teeth_scene : PackedScene
@export var patrol_radius = 10
@export var patrol_center = Vector3(0, 6, -13)
@export var patrol_speed = 0.5 
@export var nail_scene : PackedScene

var current_state = "patrol"
var can_damage = false
var hp = 20
var player = null
var patrol_angle = 0.0 
var dead = false

func _ready():
	position = patrol_center + Vector3(0, 0, -patrol_radius) 
	set_physics_process(false)
	patrol()
	
func _process(delta):
	match current_state:
		"patrol":
			if not dead:
				patrol_movement(delta)
		"full_field":
			if not dead:
				full_field_attack()
		"focus":
			if not dead:
				focus_attack()
		"nudge":
			if not dead:
				nudge_player()

func patrol():
	current_state = "patrol"
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
		await get_tree().create_timer(2).timeout
		player.set_process(true)
		player.set_physics_process(true)
		player = null


func full_field_attack():
	current_state = "full_field"
	pass

func focus_attack():
	current_state = "focus"
	pass

func nudge_player():
	if player != null:
		current_state = "nudge"
		var player_position = player.global_transform.origin
		var direction = (player_position - global_transform.origin).normalized()
		var target_position = player_position - direction * 2.0
		var duration = 1.0
		var trans_type = Tween.TRANS_LINEAR
		var ease_type = Tween.EASE_IN_OUT
		interpolate_to(target_position, duration, trans_type, ease_type)
		await get_tree().create_timer(duration).timeout
		apply_impulse_to_player()
		await get_tree().create_timer(1.0).timeout
		current_state = "focus"

func apply_impulse_to_player():
	if player != null:
		var impulse_direction = (player.global_transform.origin - global_transform.origin).normalized()
		var impulse_strength = 10.0
		player.apply_central_impulse(impulse_direction * impulse_strength)

func crystal_destroyed():
	roar()
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
	if not dead:
		dead = true
		current_state = "dead"
		collision_layer = 0
		collision_mask = 0
		var fall_speed = 10.0
		velocity = Vector3.DOWN * fall_speed
		await get_tree().create_timer(2).timeout
		queue_free()

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

func interpolate_to(target_position: Vector3, duration: float, trans_type: int, ease_type: int):
	var tween = get_tree().create_tween()
	tween.set_trans(trans_type)
	tween.set_ease(ease_type)
	tween.tween_property(self, "global_transform:origin", target_position, duration)
	tween.play()
