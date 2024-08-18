extends Area2D
class_name Explosion

@onready var explosion: AnimatedSprite2D = $Explosion

func _ready() -> void:
	explosion.play("default")


func _on_explosion_animation_finished() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("cannon") and body is Cannon:
		var cannon: Cannon = body
		cannon.take_damage(50)
