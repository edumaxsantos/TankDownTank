extends Node2D
class_name AmmoManager

@export var total_ammo: int
@export var ammo_layout: AmmoLayout

func can_shoot() -> bool:
	return total_ammo > 0

func decrease_ammo() -> void:
	total_ammo -= 1
	ammo_layout.emit_signal('update_ammo', total_ammo)
