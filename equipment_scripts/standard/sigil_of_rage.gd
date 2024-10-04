extends Equipment
func _set_property():
    default_countdown = 3.0
    GameManager.instance.damage_buff += 1

func _on_equipment_drop():
    GameManager.instance.damage_buff -= 1

