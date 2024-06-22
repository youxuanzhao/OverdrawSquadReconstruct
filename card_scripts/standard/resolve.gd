extends Card

func _on_card_play():
    GameManager.instance.discard(2)
    GameManager.instance.recover_mana(12)