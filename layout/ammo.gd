extends Control
class_name AmmoLayout

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect
@export var ammo_manager: AmmoManager

func _ready() -> void:
	ammo_manager.connect("ammo_changed", _on_ammo_changed)


func _on_ammo_changed(current_sprite: Sprite2D, current_ammo: int) -> void:
	texture_rect.texture = current_sprite.texture
	label.text = "x" + str(current_ammo)
