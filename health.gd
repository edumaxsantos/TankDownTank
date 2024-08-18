extends Node2D
class_name Health

@export var max_health: float
## Target node to apply blink effect
@export var target_node: Node2D
var current_health: float

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var _blink_timer: Timer = $BlinkTimer

var _shader_material: ShaderMaterial

func _ready() -> void:
	current_health = max_health
	progress_bar.value = max_health
	progress_bar.min_value = 0
	progress_bar.max_value = max_health
	_shader_material = target_node.material
	

func _process(_delta: float) -> void:
	progress_bar.value = current_health
	
func is_dead() -> bool:
	return current_health == 0
	
func take_damage(damage: float) -> void:
	_blink_node()
	current_health -= damage
	
	current_health = clampf(current_health, progress_bar.min_value, progress_bar.max_value)

	progress_bar.visible = true
	timer.start()

func _blink_node() -> void:
	_shader_material.set_shader_parameter("apply_white", true)
	_blink_timer.start()

func _on_timer_timeout() -> void:
	progress_bar.visible = false

func _on_blink_timer_timeout() -> void:
	_shader_material.set_shader_parameter("apply_white", false)
