class_name EntityBar
extends Node2D

#The offset is temporarily set manually.
@export var y_offset: float = 340.0
@export var x_offset: float = 160.0

@onready var HealthBar: TextureProgressBar = $HBoxContainer/HealthBar
@onready var Action: TextureProgressBar = $HBoxContainer/Action
@onready var HealthText: Label = $HBoxContainer/HealthBar/HealthText
@onready var ActionToolTip: Sprite2D = $HBoxContainer/Action/ActionToolTip
@onready var ActionLabel: Label = $HBoxContainer/Action/ActionLabel
@onready var EntityStatusHolder: StatusHolder = $StatusHolder

var owner_entity: Entity
var owner_entity_container: EntityContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_property(owner_entity,owner_entity_container)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	HealthText.text = str(HealthBar.value,"/",HealthBar.max_value)

func set_bar_owner(entity: Entity, entity_container: EntityContainer) -> void:
	owner_entity = entity
	owner_entity_container = entity_container

func set_property(entity: Entity, entity_container: EntityContainer) -> void:
	position = GameManager.instance.camera.unproject_position(entity_container.position)
	HealthBar.max_value = entity.max_health
	HealthBar.value = entity.current_health
	Action.max_value = entity.countdown
	Action.value = entity.countdown
	Action.step = 0.001
	position.y -= y_offset
	position.x -= x_offset

func update_tooltip(intent: Intent):
	if intent.has_number:
		ActionLabel.visible = true
		ActionLabel.text = str(intent.intent_number)
	else:
		ActionLabel.visible = false
	
	ActionToolTip.texture = intent.tooltip_image
