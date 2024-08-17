extends CharacterBody2D
class_name Cannon

@export var speed: float = 200
@export var _ammo_manager: AmmoManager
@export var initial_health: float

@onready var _health: Health = $Health
@onready var _base: Sprite2D = $Base
@onready var _barrel: Sprite2D = $Barrel
@onready var _bullet_spawn_point: Node2D = $Barrel/BulletSpawnPoint

func _ready() -> void:
	_health.max_health = initial_health
	
func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_rotation(delta)
	_handle_mouse_rotation()
	_handle_left_click()
	
func _handle_rotation(delta: float) -> void:
	var initial_rotation: float = 0
	
	if Input.is_action_pressed("left"):
		initial_rotation = -10
		
	if Input.is_action_pressed("right"):
		initial_rotation = 10
	
	_base.rotate(deg_to_rad(2 * initial_rotation * delta))


func _handle_movement(delta: float) -> void:
	var direction = Vector2(sin(_base.rotation), -cos(_base.rotation))
	
	if Input.is_action_pressed("forward"):
		position += direction * speed * delta
		
	if Input.is_action_pressed("backward"):
		position -= direction * speed * delta
	move_and_slide()
		
func _handle_mouse_rotation() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	
	_barrel.look_at(mouse_position)
	_barrel.rotation += PI / 2
	
func _handle_left_click() -> void:
	if not Input.is_action_just_pressed("shoot"):
		return
	
	_handle_explosion()
	_handle_bullet()
	
func _handle_explosion() -> void:
	var explosion: AnimatedSprite2D = load("res://entities/bullet/explosion/explosion.tscn").instantiate()
	
	explosion.global_position = _bullet_spawn_point.global_position
	explosion.top_level = true
	
	explosion.play("default")
	
	explosion.animation_finished.connect(func(): explosion.queue_free())
	
	add_child(explosion)
	
func _handle_bullet() -> void:
	if  not _ammo_manager.can_shoot(): return
	
	var mouse_position = get_viewport().get_mouse_position()
	var bullet: Bullet = Bullet.create_bullet(_bullet_spawn_point.global_position, mouse_position)
	get_parent().add_child(bullet)
	_ammo_manager.decrease_ammo()
