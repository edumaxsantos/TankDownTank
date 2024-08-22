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
@onready var _track_scene: PackedScene = load("res://entities/track.tscn")

var _bullet: Bullet
var _can_fire: bool
var _velocity: Vector2

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
		
	var rotation_val: float = deg_to_rad(2 * initial_rotation * delta)
	
	_base.rotate(rotation_val)
	_collision.rotate(rotation_val)

func _handle_movement(delta: float) -> void:
	var direction: Vector2 = Vector2(sin(_base.rotation), -cos(_base.rotation))
	_velocity = Vector2.ZERO

	if Input.is_action_pressed("forward"):
		_velocity += direction * speed * delta
		
	if Input.is_action_pressed("backward"):
		_velocity -= direction * speed * delta
	
	position += _velocity
		
	move_and_slide()

func _handle_mouse_rotation() -> void:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	
	_barrel.look_at(mouse_position)
	_barrel.rotation += PI / 2

func _handle_right_click() -> void:
	if not Input.is_action_just_pressed("change_ammo"):
		return
		
	_ammo_manager.change_selected_ammo()
		
	_bullet = _ammo_manager.get_bullet_instance()
	_fire_timer.stop()
	_can_fire = false
	#if _fire_timer.is_stopped():
	_fire_timer.wait_time = _bullet.reload_rate
	_fire_timer.start()
	
	
func _handle_left_click() -> void:
	if not Input.is_action_pressed("shoot"):
		return
		
	if not _can_fire: return
	
	_handle_explosion()
	_handle_bullet()
	
func _handle_explosion() -> void:
	
	if not _bullet.display_smoke: return
	
	var explosion_scene: PackedScene = load("res://entities/bullet/explosion/explosion.tscn")
	
	var explosion: AnimatedSprite2D = explosion_scene.instantiate()
	
	explosion.global_position = _bullet_spawn_point.global_position
	explosion.top_level = true
	
	explosion.play("default")
	
	explosion.animation_finished.connect(func() -> void: explosion.queue_free())
	
	add_child(explosion)

func _handle_bullet() -> void:
	if  not _ammo_manager.can_shoot(): return
	
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var direction: Vector2 = (mouse_position - _barrel.global_position).normalized()
	
	var bullet: Bullet = _bullet.duplicate()

	bullet.direction = direction
	bullet.spawn_position = _bullet_spawn_point.global_position
	get_parent().add_child(bullet)
	_ammo_manager.decrease_ammo()
	_can_fire = false
	_fire_timer.start()
	
func _handle_track() -> void:
	var track: Track = _track_scene.instantiate()
	track.global_position = _collision.global_position
	_fix_track_offset(track)
	track.rotation = _collision.rotation
	track.top_level = true
	track.z_index = 1
	get_parent().add_child(track)
	
func _fix_track_offset(track: Track) -> void:
	print_debug(_velocity)
	if _velocity.x > 0.5:
		track.global_position.x -= 10
	if _velocity.x < -0.5:
		track.global_position.x += 10
	if _velocity.y > 0.5:
		track.global_position.y -= 10
	if _velocity.y < -0.5:
		track.global_position.y += 10

func _on_fire_timer_timeout() -> void:
	_can_fire = true
	_fire_timer.wait_time = _bullet.reload_rate


func _on_track_timer_timeout() -> void:
	if _velocity != Vector2.ZERO:
		_handle_track()
