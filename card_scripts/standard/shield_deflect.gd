extends Card

func _on_card_play():
    GameManager.instance.absorb(3,"player")
    GameManager.instance.inflict_status("standard","deflect",3,"player")