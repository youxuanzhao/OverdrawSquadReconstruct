extends Equipment

func _set_property():
	default_countdown = 3.0

func _on_timeout():
	_on_activate()

func _on_activate():
	if GameManager.instance.player_mp >= cost:
		GameManager.instance.player_mp -= cost
		GameManager.instance.generate_card("test","defend",1)
	else:
		pause_resume()
