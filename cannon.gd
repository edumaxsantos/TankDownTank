extends CharacterBody2D
class_name Cannon

@export var speed: float = 200
@export var health: Health

@export_group("Ammo")
@export var _ammo_manager: AmmoManager
@export var bullet_type: AmmoManager.Ammo

@onready var _base: Sprite2D = %Base
@onready var _barrel: Sprite2D = %Barrel
@onready var _bullet_spawn_point: Node2D = %Barrel/BulletSpawnPoint
@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _fire_timer: Timer = $FireTimer

var _bullet: Bullet
var _can_fire: bool

func _ready() -> void:
	_can_fire = false
	_ammo_manager.add_ammo(AmmoManager.Ammo.Normal, 30)
	_ammo_manager.add_ammo(AmmoManager.Ammo.Fast, 200)
	_ammo_manager.selected_ammo = bullet_type
	_bullet = _ammo_manager.get_bullet_instance()
	_fire_timer.wait_time = _bullet.reload_rate

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_rotation(delta)
	_handle_mouse_rotation()
	_handle_left_click()
	_handle_right_click()

func take_damage(damage: float) -> void:
	health.take_damage(damage)
	
	
func _handle_rotation(delta: float) -> void:
	var initial_rotation: float = 0
	
	if Input.is_action_pressed("left"):
		initial_rotation = -10
		
	if Input.is_action_pressed("right"):
		initial_rotation = 10
		
	var rotation_val = deg_to_rad(2 * initial_rotation * delta)
	
	_base.rotate(rotation_val)
	_collision.rotate(rotation_val)

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

func _handle_right_click() -> void:
	if not Input.is_action_just_pressed("change_ammo"):
		return
		
	_ammo_manager.change_selected_ammo()
		
	_bullet = _ammo_manager.get_bullet_instance()
	
	
func _handle_left_click() -> void:
	if not Input.is_action_pressed("shoot"):
		return
		
	if not _can_fire: return
	
	_can_fire = false
	
	_handle_explosion()
	_handle_bullet()
	
func _handle_explosion() -> void:
	
	if not _bullet.display_smoke: return
	
	var explosion: AnimatedSprite2D = load("res://entities/bullet/explosion/explosion.tscn").instantiate()
	
	explosion.global_position = _bullet_spawn_point.global_position
	explosion.top_level = true
	
	explosion.play("default")
	
	explosion.animation_finished.connect(func(): explosion.queue_free())
	
	add_child(explosion)

func _handle_bullet() -> void:
	if  not _ammo_manager.can_shoot(): return
	
	var mouse_position = get_viewport().get_mouse_position()
	var direction = (mouse_position - _barrel.global_position).normalized()
	
	var bullet = _bullet.duplicate()

	bullet.direction = direction
	bullet.spawn_position = _bullet_spawn_point.global_position
	get_parent().add_child(bullet)
	_ammo_manager.decrease_ammo()

func _on_fire_timer_timeout() -> void:
	_can_fire = true
	_fire_timer.wait_time = _bullet.reload_rate
