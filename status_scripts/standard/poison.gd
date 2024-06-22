extends Status

func _init():
    pass

func _on_effect_trigger():
    if target == "player":
        GameManager.instance.damage_player(intensity,true)

func _on_decay():
    _on_effect_trigger()
    intensity-=1
    if intensity <= 0:
        is_active = false