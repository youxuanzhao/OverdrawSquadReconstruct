extends Equipment
func _set_property():
    default_countdown = 3.0

func _on_timeout():
    _on_activate()

func _on_activate():
    GameManager.instance.damage_player(1,true)
    GameManager.instance.damage_enemy(2,false,false)
