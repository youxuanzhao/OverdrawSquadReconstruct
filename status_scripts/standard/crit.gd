extends Status

func _init():
    GameManager.instance.s_critical_damage.connect(_on_effect_trigger)

func _on_effect_trigger():
    remove_all_stacks()
    set_critical_chance()

func _on_decay():
    intensity-=1
    set_critical_chance()

func _on_gain_stack():
    set_critical_chance()

func set_critical_chance():
    GameManager.instance.critical_chance = float(intensity) * 0.1