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


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("barrier"):
		body.take_damage(damage)
	
	queue_free()
