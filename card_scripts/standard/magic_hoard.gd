extends Card

func _on_card_play():
    GameManager.instance.recover_mana(20)