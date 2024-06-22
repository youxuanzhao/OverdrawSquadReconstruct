class_name EntityContainer
extends Node3D

var entity = Entity.new()

@onready var cardBack: Sprite3D = $CardBack
@onready var cardArt: Sprite3D = $CardArt
@onready var cardFrame: Sprite3D = $CardFrame
@onready var cardLabel: Sprite3D = $CardLabel
@onready var carLabelText: Label3D = $CardLabel/CardLabelText

var has_entity_bar = false
var has_entered_combat = false 


func _ready() -> void:
	pass

func enter_combat() -> void:
	has_entered_combat = true
	entity._on_entity_spawn()
	entity.entity_bar_id = GameManager.instance.request_entity_bar(entity,self)
	has_entity_bar = true
	instance_from_id(entity.entity_bar_id).update_tooltip(entity.intent_cycle.get_current_intent())

func _process(delta) -> void:
	if has_entered_combat:
		if entity.current_health <= 0:
			kill()

		if has_entity_bar:
			entity.update_display_health()
			entity.update_display_timer()

func kill() -> void:
	entity._on_entity_died(self)
	GameManager.instance.remove_entity_bar(entity.entity_bar_id)
	queue_free()
