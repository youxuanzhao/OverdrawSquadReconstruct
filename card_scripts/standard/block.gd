extends Card

func _on_card_play():
    GameManager.instance.absorb(5,"player")