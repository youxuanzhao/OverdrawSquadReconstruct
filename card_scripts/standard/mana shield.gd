extends Card

func _on_card_play():
    GameManager.instance.absorb(8,"player")
    GameManager.instance.player_mp -= 8