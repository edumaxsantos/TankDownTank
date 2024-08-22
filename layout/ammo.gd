extends Control
class_name AmmoLayout

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect
@export var ammo_manager: AmmoManager

@onready var _reload_time: float

var _shader_material: ShaderMaterial
var _elapsed_time: float

func _ready() -> void:
	ammo_manager.connect("ammo_changed", _on_ammo_changed)
	var current_bullet: Bullet = ammo_manager.get_bullet_instance()
	var current_bullet_sprite: Sprite2D = current_bullet.get_node("Sprite2D")
	
	texture_rect.texture = current_bullet_sprite.texture
	label.text = "x" + str(ammo_manager.get_quantity(ammo_manager.selected_ammo))
	_reload_time = current_bullet.reload_rate
	_shader_material = texture_rect.material
	_elapsed_time = 0.0

func _process(delta: float) -> void:
	if _elapsed_time < _reload_time:
		_elapsed_time += delta
		var progress: float = clampf(_elapsed_time / _reload_time, 0.0, 1.0)
		_shader_material.set_shader_parameter("progress", progress)
	else:
		# Optional: Reset or stop the effect when it completes
		_shader_material.set_shader_parameter("progress", 1)

func _on_ammo_changed(current_sprite: Sprite2D, current_ammo: int) -> void:
	texture_rect.texture = current_sprite.texture
	label.text = "x" + str(current_ammo)
	var current_bullet: Bullet = ammo_manager.get_bullet_instance()
	_reload_time = current_bullet.reload_rate
	_shader_material.set_shader_parameter("progress", 0.0)
	_elapsed_time = 0.0
