extends Area2D
class_name Bullet

@export var speed: float = 400
@export var damage: float

var _direction: Vector2

static func create_bullet(spawn_position: Vector2, direction: Vector2) -> Bullet:
	var bullet_scene: PackedScene = load("res://entities/bullet/bullet.tscn")
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.top_level = true
	bullet.global_position = spawn_position
	
	bullet._direction = direction
	
	bullet.rotation = direction.angle() + deg_to_rad(90)
	
	return bullet
	
func _physics_process(delta: float) -> void:
	var velocity = _direction * speed
	
	translate(velocity * delta)
	
	#var collision = move_and_collide(velocity * delta)
	
	#_handle_collision(collision)
	
	
func _handle_collision(collision: KinematicCollision2D) -> void:
	if collision == null: return
	
	var collider: Node2D = collision.get_collider()
	
	if (collider.is_in_group("obstacles")):
		var obstacle: Obstacle = collider
		obstacle.take_damage(50)
	if (collider.is_in_group("projectiles")):
		var projectile: CharacterBody2D = collider
		if (projectile.get_parent() == get_parent()):
			print("same parent")
			return
	#if (collider.is_in_group("enemies")):
	#	enemy.take_damage(50)
	
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.take_damage(damage)
	queue_free()
