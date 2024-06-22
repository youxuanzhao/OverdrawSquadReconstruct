extends Card

func _on_card_play():
    for i in range(1):
        var temp = randi_range(1,6)
        match temp:
            1:GameManager.instance.activate("head")
            2:GameManager.instance.activate("chest")
            3:GameManager.instance.activate("mainHand")
            4:GameManager.instance.activate("offHand")
            5:GameManager.instance.activate("ring")
            6:GameManager.instance.activate("trinkit")   
            _:
                pass