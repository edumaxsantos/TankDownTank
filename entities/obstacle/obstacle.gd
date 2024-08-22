extends StaticBody2D
class_name Obstacle

@onready var health: Health = $Health
@onready var sprite: Sprite2D = $Sprite2D


func _process(_delta: float) -> void:
	_handle_explosion()
	


func take_damage(damage: float) -> void:
	health.take_damage(damage)

func _handle_explosion() -> void:
	if not health.is_dead(): return
	
	var explosion_scene: PackedScene = load("res://entities/obstacle/explosion.tscn")
	
	var explosion: Explosion = explosion_scene.instantiate()
	
	explosion.global_position = global_position
	explosion.top_level = true
	
	get_parent().add_child(explosion)
	queue_free()
