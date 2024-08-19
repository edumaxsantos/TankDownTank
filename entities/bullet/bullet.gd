extends Area2D
## Basic class for bullet. Defines the general
## properties and methods for all bullets
class_name Bullet


@export var speed: float = 400
@export var damage: float
@export var spawn_position: Vector2
@export var direction: Vector2

func _ready() -> void:
	top_level = true
	global_position = spawn_position
	rotation = direction.angle() + deg_to_rad(90)

	
func _physics_process(delta: float) -> void:
	var velocity = direction * speed
	
	translate(velocity * delta)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("barrier"):
		body.take_damage(damage)
	
	queue_free()
