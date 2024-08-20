extends Node2D

@onready var cannon: Cannon = $Cannon

func _init() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
