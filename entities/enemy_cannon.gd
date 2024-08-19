extends CharacterBody2D
class_name EnemyCannon

@onready var _health: Health = $Health

func _process(_delta: float) -> void:
	if _health.is_dead():
		queue_free()

func take_damage(damage: float) -> void:
	_health.take_damage(damage)
