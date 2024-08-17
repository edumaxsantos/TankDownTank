extends Node2D
class_name Health

@export var max_health: float

var current_health: float

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	current_health = max_health
	progress_bar.value = max_health
	progress_bar.min_value = 0
	progress_bar.max_value = max_health

func _process(_delta: float) -> void:
	progress_bar.value = current_health
	
func is_dead() -> bool:
	return current_health == 0
	
func take_damage(damage: float) -> void:
	current_health -= damage
	
	current_health = clampf(current_health, progress_bar.min_value, progress_bar.max_value)
	progress_bar.visible = true
	timer.start()

func _on_timer_timeout() -> void:
	progress_bar.visible = false
