extends CharacterBody2D

@export var movement_speed: float = 80

@onready var state_machine: StateMachine = $StateMachine
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprites = $sprites
@onready var collision = $CollisionShape2D
@onready var body_sprites = $sprites/body/sprites

func _ready():
	initialize_sprites()

func change_state(new_state: String, msg: Dictionary = {}) -> void:
	if state_machine.state != get_node(new_state):
		state_machine.transition_to(new_state, msg)

func _physics_process(_delta):
	set_sprite_direction()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		initialize_sprites()

func set_sprite_direction():
	var angle = global_position.angle_to_point(navigation_agent.target_position)
	if abs(angle) > PI/2:
		sprites.scale.x = 1
	else:
		sprites.scale.x = -1

func initialize_sprites():
	for sprite in body_sprites.get_children():
		sprite.frame = randi_range(0, sprite.hframes - 1)
