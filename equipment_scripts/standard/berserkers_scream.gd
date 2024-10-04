extends Equipment
func _set_property():
    default_countdown = 100.0
    GameManager.instance.s_played_card.connect(effect)

func _on_timeout():
    _on_activate()

func _on_activate():
    pass

func effect(type: String):
    if type == "attack":
        GameManager.instance.inflict_status("standard", "crit", 1, "player")
