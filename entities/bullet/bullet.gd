extends Area2D
## Basic class for bullet. Defines the general
## properties and methods for all bullets
class_name Bullet


@export var speed: float = 400
@export var damage: float
## how fast it is to reload and be allowed to shoot again.
## the lower the number, the faster you can shoot.
## Measured in seconds.
@export var reload_rate: float
@export var display_smoke: bool = true


@onready var spawn_position: Vector2
@onready var direction: Vector2
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	top_level = true
	global_position = spawn_position
	rotation = direction.angle() + deg_to_rad(90)
	
	if sprite == null:
		push_error("missing sprite")

	
func _physics_process(delta: float) -> void:
	var velocity: Vector2 = direction * speed
	
	translate(velocity * delta)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("barrier") and body.has_method("take_damage"):
		body.take_damage(damage)
	
	queue_free()
