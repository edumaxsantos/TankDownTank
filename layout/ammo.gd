extends Control
class_name AmmoLayout

@onready var label: Label = $Label
#warning-ignore:unused_signal
signal update_ammo(current_ammo: int)


func _on_update_ammo(current_ammo: int) -> void:
	label.text = "x" + str(current_ammo)
