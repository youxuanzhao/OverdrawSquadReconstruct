class_name EquipmentHolder
extends HBoxContainer


static var instance: EquipmentHolder



func _ready() -> void:
	instance = self

func equipToSlot(equipment:Equipment) -> void:
	for i in get_children():
		if i.body_part == equipment.get_body_part():
			i.equipment = equipment
			i.connect_signals()
			i.reset_pause_status()
			i.equipment._on_equipment_equip()
			break

func get_body_part(body_part:String) -> EquipmentSlot:
	for i in get_children():
		if i.body_part == body_part:
			return i
	return null

func activate(body_part:String) -> void:
	var temp = get_body_part(body_part)
	if temp != null and temp.equipment != null:
		temp.equipment._on_activate()
