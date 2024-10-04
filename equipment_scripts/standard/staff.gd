extends Equipment
func _set_property():
    default_countdown = 3.0

func _on_timeout():
    _on_activate()

func _on_activate():
    if GameManager.instance.player_mp >= cost:
        GameManager.instance.player_mp -= cost
        var rand = randi() % 3
        match rand:
            0:
                GameManager.instance.generate_card("standard","lightning_bolt",1)
            1:
                GameManager.instance.generate_card("standard","fireball",1)
            2:
                GameManager.instance.generate_card("standard","counterspell",1)
    else:
        pause_resume()

