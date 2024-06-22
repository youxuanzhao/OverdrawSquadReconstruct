class_name CardHolder
extends Node2D

static var instance: CardHolder

var card_template_scene: PackedScene = preload("res://scene_files/card_container.tscn")
var select_fixation: bool = false

func _ready():
	instance = self

func add_card(src: Card) -> void:
	if get_child_count() < GameManager.instance.max_hand_count:
		var temp: CardContainer = card_template_scene.instantiate()
		temp.card = src
		temp.position = Vector2(1100,0)
		add_child(temp)
		card_fan()

func get_card_amount() -> int:
	return get_child_count()

func discard_selected(selection: Array) -> void:
	var count_1 = 0
	var count_2 = 0
	for i in get_children():
		if count_1 == selection[count_2]:
			i.play_discard()
			count_2 += 1
			if count_2 >= selection.size():
				break
		count_1 += 1
	var temp_timer = get_tree().create_timer(1.02)
	temp_timer.timeout.connect(card_fan)


func discard_all() -> void:
	for i in get_children():
		i.play_discard()

func card_fan() -> void:
	var cnt = 1
	for i in get_children():
		i.auto_fan(cnt,get_child_count())
		cnt+=1

func update_hovering_status() -> void:
	for i in get_children():
		i.update_hovering_status()

func _process(delta) -> void:
	if Input.is_action_just_released("left_click"):
		var htween = get_tree().create_tween().set_parallel()
		htween.tween_callback(card_fan).set_delay(0.1)
