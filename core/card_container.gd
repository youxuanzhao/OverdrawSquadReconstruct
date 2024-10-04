class_name CardContainer
extends Node2D

var card: Card = Card.new()

@onready var cardFrame : Sprite2D = $Local/CardFrame
@onready var cardBack : Sprite2D = $Local/CardBack
@onready var cardArt : Sprite2D = $Local/CardArt
@onready var cardNameLabel : RichTextLabel = $Local/Container/VBoxContainer/CardNameText
@onready var descLabel : RichTextLabel = $Local/Container/VBoxContainer/DescText
@onready var animPlayer : AnimationPlayer = $Local/AnimationPlayer
@onready var detectArea : Area2D = $Local/DetectArea
@onready var selectCooldown : Timer = $SelectCooldown

var isHovering : bool = false
var select_cooldown_time : float = 0.2
var is_select_cooldown : bool = false
var isHolding : bool = false
var is_hovering_this_card : bool = false
var holdingOffset: Vector2


func _process(delta):
	cardArt.texture = card.card_resource
	cardNameLabel.text = str(card.card_display_name_bbcode,card.card_display_name)
	descLabel.text = str(card.card_display_desc_bbcode,card.card_display_desc)

	if Input.is_action_just_pressed("left_click") && isHovering:
		isHolding = true
		holdingOffset = get_global_mouse_position() - position
	
	if Input.is_action_just_released("left_click") && isHolding:
		isHolding = false
		GameManager.instance.is_hovering_on_card = false
		is_hovering_this_card = false
		if GameManager.instance.out_of_hand_detection.overlaps_area($Local/DetectArea):
			CardHolder.instance.card_fan()
		else:
			card._on_card_play()
			CardHolder.instance.card_fan()
			GameManager.instance.s_played_card.emit(card.type)
			animPlayer.play("play")
	if isHolding:
		position = get_global_mouse_position() - holdingOffset
	
	if isHovering:
		cardFrame.material = preload("res://assets/material/outline.tres")
	else:
		cardFrame.material = null



func _on_detect_area_mouse_entered() -> void:
	if is_select_cooldown:
		return
	isHovering = true
	if !GameManager.instance.is_hovering_on_card:
		is_hovering_this_card = true
		detectArea.priority = 1
		z_index = 1
		GameManager.instance.is_hovering_on_card = true
		CardHolder.instance.card_fan()

func update_hovering_status() -> void:
	if isHovering and !GameManager.instance.is_hovering_on_card and !is_hovering_this_card:
		is_hovering_this_card = true
		detectArea.priority = 1
		z_index = 1
		GameManager.instance.is_hovering_on_card = true
		CardHolder.instance.card_fan()

func _on_detect_area_mouse_exited() -> void:
	isHovering = false
	if GameManager.instance.is_hovering_on_card and is_hovering_this_card:
		selectCooldown.start(select_cooldown_time)
		is_select_cooldown = true
		is_hovering_this_card = false
		detectArea.priority = 0
		z_index = 0
		GameManager.instance.is_hovering_on_card = false
		CardHolder.instance.update_hovering_status()
		CardHolder.instance.card_fan()

func get_card() -> Card:
	return card

func auto_fan(current_position : int, hand_count : int) -> void:
	if isHolding:
		return
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	var midpoint = float(hand_count+1)/2
	var total_rad
	if hand_count!=1:
		if isHovering:
			total_rad= -(midpoint - current_position) * deg_to_rad(GameManager.instance.default_card_rotation_degree)
			tween.tween_property(self,"rotation", GameManager.instance.on_hover_card_rotation_degree,GameManager.instance.hand_anim_speed_fast)
			tween.tween_property(self,"position",Vector2(sin(total_rad)*GameManager.instance.on_hover_card_fan_radius, ((1-cos(total_rad))*GameManager.instance.on_hover_card_fan_radius)-GameManager.instance.offset_card_fan_y_offset),GameManager.instance.hand_anim_speed_fast)
		else:
			total_rad= -(midpoint - current_position) * deg_to_rad(GameManager.instance.default_card_rotation_degree)
			tween.tween_property(self,"rotation", total_rad,GameManager.instance.hand_anim_speed)
			tween.tween_property(self,"position",Vector2(sin(total_rad)*GameManager.instance.offset_card_fan_radius, (1-cos(total_rad))*GameManager.instance.offset_card_fan_radius),GameManager.instance.hand_anim_speed)
	
	elif hand_count == 1:
		if isHovering:
			tween.tween_property(self,"rotation", 0,GameManager.instance.hand_anim_speed_fast)
			tween.tween_property(self,"position",Vector2(0,-GameManager.instance.offset_card_fan_y_offset),GameManager.instance.hand_anim_speed_fast)
		else:
			tween.tween_property(self,"rotation", 0,GameManager.instance.hand_anim_speed)
			tween.tween_property(self,"position",Vector2(0,0),GameManager.instance.hand_anim_speed)

func play_discard():
	animPlayer.play("discard")

func discard():
	card._on_card_discard()
	queue_free()


func _on_select_cooldown_timeout():
	is_select_cooldown = false
