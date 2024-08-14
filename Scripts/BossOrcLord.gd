extends CharacterBody3D

@export var close_range_attack_damage: int = 2
@export var close_range_attack_distance: float = 2.0
@onready var player: Node3D = get_tree().get_first_node_in_group("player")
@export var max_health: int = 8
var health: int = max_health
@export var speed: float = 2.0
@export var rush_speed_multiplier: float = 2.5
@onready var attack_area: Area3D = $AttackArea
@onready var state_machine: Node = $StateMachine
@export var scream_distance: float = 15.0
@export var scream_slow_duration: float = 1.0
@export var scream_slow_factor: float = 0.5
@export var minion_scene: PackedScene
@export var teeth_scene : PackedScene
@export var club_scene : PackedScene
var dead = false

func _ready() -> void:
	randomize()
	initialize_state_machine()

func _physics_process(delta: float) -> void:
	if not dead:
		state_machine.process(delta)

func initialize_state_machine() -> void:
	for child in state_machine.get_children():
		if child is State:
			child.boss = self
			child.state_machine = state_machine

	state_machine.start() 

func minus_hp(damage: int) -> void:
	var teeth: Node3D = teeth_scene.instantiate()
	teeth.transform.origin.y = 1
	teeth.scale = Vector3(5,5,5)
	get_parent().add_child(teeth)
	health -= damage
	if health <= 0:
		die()

func attack_player() -> void:
	if player:
		var distance_to_player: float = global_transform.origin.distance_to(player.global_transform.origin)
		if distance_to_player <= close_range_attack_distance:
			player.minus_health(close_range_attack_damage)

func perform_scream() -> void:
	if player:
		var distance_to_player: float = global_transform.origin.distance_to(player.global_transform.origin)
		if distance_to_player >= scream_distance:
			slow_down_player()
			spawn_minions()

func slow_down_player() -> void:
	if player:
		player.speed *= scream_slow_factor
		await get_tree().create_timer(scream_slow_duration).timeout
		player.speed /= scream_slow_factor

func spawn_minions() -> void:
	var minion: Node3D = minion_scene.instantiate()
	$Marker3D.add_child(minion)
	$Marker3D2.add_child(minion)

func die():
	dead = true
	%Diesfx.play()
	%Anim.play("die")
	$CollisionShape3D.disabled = true
	var teeth = teeth_scene.instantiate()
	teeth.global_transform = global_transform
	teeth.transform.origin.y = 1.1
	teeth.scale = Vector3(5,5,5)
	get_parent().add_child(teeth)
	var club = club_scene.instantiate()
	club.global_transform = global_transform
	club.transform.origin.y = 1.1
	club.scale = Vector3(5,5,5)
	get_parent().add_child(club)
	get_parent().orclord_defeated = true
	
