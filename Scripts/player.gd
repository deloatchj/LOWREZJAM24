extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 5
@export var sprint_speed = 10
@export var jump_speed = 5
@export var mouse_sensitivity = 0.002
var can_shoot = true
var is_sprinting = false
@onready var teeth = %Teeth
@onready var hand = %Hand

enum GunMode {REVOLVER, SHOTGUN, ASSAULT_RIFLE, MELEE}
var current_gun_mode = GunMode.REVOLVER
var prev_gun_mode
var meleemode = false
var new_anim : String
func _ready():
	%Hand.animation_finished.connect(shoot_anim_over)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if current_gun_mode == GunMode.REVOLVER:
		%Hand.play("idle_r")
	elif current_gun_mode == GunMode.SHOTGUN:
		%Hand.play("idle_sh")
	elif current_gun_mode == GunMode.ASSAULT_RIFLE:
		%Hand.play("idle_ar")

func _physics_process(delta):
	%Spiral.rotation += delta
	if 1 in Game.keys:
		%Key1.visible = true
		%Key1.modulate = Color.RED
	if 2 in Game.keys:
		%Key2.visible = true
		%Key2.modulate = Color.YELLOW
	match Game.player_hp:
		8:
			teeth.frame = 0
		7:
			teeth.frame = 1
		6:
			teeth.frame = 2
		5:
			teeth.frame = 3
		4:
			teeth.frame = 4
		3:
			teeth.frame = 5
		2:
			teeth.frame = 6
		1:
			teeth.frame = 7
		_:
			teeth.frame = 7
	
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
		velocity.x = movement_dir.x * sprint_speed
		velocity.z = movement_dir.z * sprint_speed
	else:
		is_sprinting = false
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		%Pause.visible = true
	
	if Input.is_action_pressed("shoot"):
		_shoot()
	if Input.is_action_just_pressed("melee") and Game.melee_unlocked:
		if meleemode:
			current_gun_mode = prev_gun_mode
			match current_gun_mode:
				GunMode.REVOLVER:
					new_anim = "idle_r"
					%Hand.play(new_anim)
				GunMode.SHOTGUN:
					new_anim = "idle_sh"
					%Hand.play(new_anim)
				GunMode.ASSAULT_RIFLE:
					new_anim = "idle_ar"
					%Hand.play(new_anim)
			meleemode = false
		else:
			%Hand.play("idle_melee")
			prev_gun_mode = current_gun_mode
			current_gun_mode = GunMode.MELEE
			meleemode = true
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _shoot():
	if !can_shoot:
		return
	
	match current_gun_mode:
		GunMode.REVOLVER:
			if Game.player_hp >= 1:
				can_shoot = false
				%Hand.play("shoot_r")
				%RShootsfx.play()
				%Shotgunfx.emitting = true
				if %Ray.is_colliding() and %Ray.get_collider().has_method("die"):
					%Ray.get_collider().minus_hp(1)
				Game.player_hp -= 1
		GunMode.SHOTGUN:
			if Game.player_hp >= 2:
				can_shoot = false
				%Hand.play("shoot_sh")
				%ShShootsfx.play()
				%Shotgunfx.emitting = true
				if %Ray.is_colliding() and %Ray.get_collider().has_method("die"):
					%Ray.get_collider().minus_hp(3)
				Game.player_hp -= 2
		GunMode.ASSAULT_RIFLE:
			if Game.player_hp >= 1:
				can_shoot = false
				%Hand.play("shoot_ar")
				%AShootsfx.play()
				%Shotgunfx.emitting = true
				if %Ray.is_colliding() and %Ray.get_collider().has_method("die"):
					%Ray.get_collider().minus_hp(2)
				Game.player_hp -= 1
				await get_tree().create_timer(0.1).timeout
				can_shoot = true
		GunMode.MELEE:
			if Game.melee_unlocked:
				_melee_attack()

func _melee_attack():
		if !can_shoot:
				return
		%Meleesfx.play()
		can_shoot = false
		var bodies = %MeleeArea.get_overlapping_bodies()
		%Hand.play("melee")
		for body in bodies:
			if not body.is_in_group("boss"):
				body.die()
		await get_tree().create_timer(0.25).timeout
		can_shoot = true

func shoot_anim_over():
	can_shoot = true

func minus_health(hp):
	print(Game.player_hp)
	if Game.player_hp < 1:
		%Death.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		Game.die()
	Game.player_hp -= hp
	%Hurtsfx.play()

func _on_retry_button_pressed():
	Game.retry()

func _on_exit_button_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Game.change_scene("res://Scenes/MainMenu.tscn")

func _on_resume_button_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	%Pause.visible = false
