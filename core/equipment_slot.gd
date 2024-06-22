class_name EquipmentSlot
extends Container

@export_enum(
	"head",
	"chest",
	"waist",
	"leg",
	"feet",
	"wrist",
	"hand",
	"mainHand",
	"offHand",
	"leftFinger",
	"rightFinger",
	"necklace",
) var body_part: String

var equipment: Equipment

@onready var equipment_frame : Sprite2D = $EquipmentArt
@onready var equipment_art : Sprite2D = $EquipmentFrame
@onready var equipment_cooldown_sprite : Sprite2D = $Cooldown
@onready var equipment_pause_sprite : Sprite2D = $Pause


var isHovering: bool = false
var isActive: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	equipment_cooldown_sprite.visible = false
	equipment_pause_sprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if equipment == null:
		isActive = false
	else:
		isActive = true
		
	if isActive:
		set_property()
		equipment_art.visible = true
		equipment_frame.visible = true
		equipment_cooldown_sprite.visible = true
		equipment_cooldown_sprite.scale.y = 3 * equipment.get_remaining_time()/equipment.get_total_time()
		if Input.is_action_just_pressed("left_click") && isHovering:
			equipment.pause_resume()
	else:
		equipment_art.visible = false
		equipment_frame.visible = false
		equipment_cooldown_sprite.visible = false
		equipment_pause_sprite.visible = false

func get_equipment() -> Equipment:
	return equipment

func set_property() -> void:
	equipment_frame.texture = load(str("res://assets/frame/",equipment.rarity,".png"))
	equipment_art.texture = equipment.resource


func _on_area_2d_mouse_entered() -> void:
	isHovering = true


func _on_area_2d_mouse_exited() -> void:
	isHovering = false

func change_pause_status() -> void:
	equipment_pause_sprite.visible = !equipment_pause_sprite.visible

func reset_pause_status() -> void:
	equipment_pause_sprite.visible = false


func connect_signals() -> void:
	equipment.s_pause_resume.connect(change_pause_status)
