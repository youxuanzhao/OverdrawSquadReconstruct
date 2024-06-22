extends Card

func _on_card_play():
    GameManager.instance.absorb(4,"player")
    GameManager.instance.activate("mainHand")