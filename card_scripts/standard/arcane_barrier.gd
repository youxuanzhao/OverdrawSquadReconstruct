extends Card

func _on_card_play():
    GameManager.instance.inflict_status("standard","overload",1,"enemy")