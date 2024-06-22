extends Card

func _on_card_play():
    GameManager.instance.inflict_status("standard","poison",GameManager.instance.get_intensity("poison","enemy"),"enemy")