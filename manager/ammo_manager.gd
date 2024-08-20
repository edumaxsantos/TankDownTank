extends Node2D
class_name AmmoManager

signal ammo_changed(current_sprite: Sprite2D, current_ammo: int)

enum Ammo {
	Normal, Fast
}

@onready var selected_ammo: Ammo = Ammo.Normal:
	get:
		return selected_ammo
	set(value):
		selected_ammo = value
		ammo_changed.emit(ammo_instances[value].instantiate().get_node("Sprite2D"), _get_selected_quantity())
		
		
var _ammo = {}
var ammo_instances = {
	Ammo.Normal: preload("res://entities/bullet/normal_bullet.tscn"),
	Ammo.Fast: preload("res://entities/bullet/fast_bullet.tscn")
}

func get_bullet_scene() -> PackedScene:
	return ammo_instances[selected_ammo]

func get_bullet_instance() -> Bullet:
	return get_bullet_scene().instantiate()

func _get_selected_quantity() -> int:
	return get_quantity(selected_ammo)

func get_quantity(ammo: Ammo) -> int:
	return _ammo[ammo]

func add_ammo(ammo: Ammo, quantity: int) -> void:
	if _ammo.has(ammo):
		_ammo[ammo] += quantity
	else:
		_ammo[ammo] = quantity

func can_shoot() -> bool:
	return _get_selected_quantity() > 0

func decrease_ammo() -> void:
	var instance = get_bullet_instance()
	ammo_changed.emit(instance.get_node("Sprite2D"), _get_selected_quantity() - 1)
	
func change_selected_ammo() -> void:
	if selected_ammo == Ammo.Normal:
		selected_ammo = Ammo.Fast
	elif selected_ammo == Ammo.Fast:
		selected_ammo = Ammo.Normal


func _on_ammo_changed(_current_sprite: Sprite2D, current_ammo: int) -> void:
	_ammo[selected_ammo] = current_ammo
