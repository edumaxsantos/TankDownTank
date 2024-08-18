extends Node2D
class_name AmmoManager

@export var total_ammo: int

signal ammo_changed(current_ammo: int)

func can_shoot() -> bool:
	return total_ammo > 0

func decrease_ammo() -> void:
	ammo_changed.emit(total_ammo - 1)


func _on_ammo_changed(update_total_ammo: int) -> void:
	total_ammo = update_total_ammo
