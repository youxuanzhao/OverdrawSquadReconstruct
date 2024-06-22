class_name LootContainer
extends Node3D

const COMMON = Color("949494")
const RARE = Color("00a2f0")
const EPIC = Color("e01686")


var equipment : Equipment = Equipment.new()

var is_hovering : bool = false

var pos_offset : Vector3
var has_offset : bool = false

@onready var detectArea : Area3D = $DetectArea

func _ready():
	if equipment.rarity == "common":
		$Sprite3D.modulate = COMMON
	elif equipment.rarity == "rare":
		$Sprite3D.modulate = RARE
	elif equipment.rarity == "epic":
		$Sprite3D.modulate = EPIC
	$AnimationPlayer.play("drop")
	$AnimationPlayer.queue("idle")

func load_data():
	$LootSprite.texture = equipment.resource

func _process(delta):
	print(position.z)
	if has_offset:
		self.position = pos_offset
	if Input.is_action_just_pressed("left_click") and is_hovering:
		on_loot_pick_up()

func on_loot_pick_up():
	GameManager.instance.equip_from_equipment(equipment)
	queue_free()

func _on_detect_area_mouse_entered():
	is_hovering = true


func _on_detect_area_mouse_exited():
	is_hovering = false

func tween_position():
	var temp = Vector3(randf_range(-0.5,0.5),0.1,randf_range(-1.0,-0.5))
	pos_offset = temp
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",temp,0.9)
	tween.tween_callback(toggle_offset)

func toggle_offset():
	has_offset = true
