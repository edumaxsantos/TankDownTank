extends Node2D
class_name Track


func _on_timer_timeout() -> void:
	queue_free()
