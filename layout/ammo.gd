extends Control
class_name AmmoLayout

@onready var label: Label = $Label
@export var ammo_manager: AmmoManager

func _ready() -> void:
	ammo_manager.connect("ammo_changed", _on_ammo_changed)


func _on_ammo_changed(current_ammo: int) -> void:
	label.text = "x" + str(current_ammo)
