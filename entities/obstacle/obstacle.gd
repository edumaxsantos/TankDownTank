extends StaticBody2D
class_name Obstacle

@onready var health: Health = $Health

func _process(_delta: float) -> void:
	if health.is_dead():
		queue_free()


func take_damage(damage: float) -> void:
	health.take_damage(damage)
