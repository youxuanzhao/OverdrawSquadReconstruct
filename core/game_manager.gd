class_name GameManager
extends Node3D

# This is the script of GamaManager.
# GameManager handles events inside game, while controlling every objects inside it.

static var instance: GameManager
@export_category("Stage Monitor")
@export_enum(
	"test1",
	"test2",
) var stage: String

@export_category("Player Configuration")
@export var player_hp : float = 100
@export var player_hp_max : float = 100
@export var player_hp_regen : float = 0.0
@export var player_mp : float = 100
@export var player_mp_max : float = 100
@export var player_mp_regen : float = 2.0
@export var max_hand_count: int = 8
@export var hand_anim_speed: float = 0.5
@export var hand_anim_speed_fast: float = 0.1
@export var default_card_rotation_degree: float = 4.0
@export var on_hover_card_rotation_degree: float = 0.0
@export var offset_card_rotation_degree: float = 4.5
@export var default_card_fan_radius: float = 3000.0
@export var on_hover_card_fan_radius: float = 3500.0
@export var offset_card_fan_radius: float = 3000.0
@export var offset_card_fan_y_offset: float = 20

# Modifiers
@export var critical_chance: float = 0
@export var critical_damage_modifier: float = 2
@export var global_cooldown_modifier: float = 1
@export var damage_buff: int = 0
@export var attack_buff: int = 0
@export var spell_damage_buff: int = 0
@export var spell_cost_modifier: int = 0


var equipment_database : JSON = preload("res://data/equipment_database.json")
var card_database : JSON = preload("res://data/card_database.json")
var entity_database : JSON = preload("res://data/entity_database.json")
var status_database : JSON = preload("res://data/status_database.json")
var init_list : JSON = preload("res://data/init_list.json")


 
@onready var out_of_hand_detection : Area2D = $CanvasLayer/OutOfHandDetection
@onready var camera: Camera3D = $Camera
@onready var player_health_bar : TextureProgressBar = $CanvasLayer/PlayerHealthBar
@onready var player_health_bar_display : Label = $CanvasLayer/PlayerHealthBarDisplay
@onready var player_mana_bar : ProgressBar = $CanvasLayer/PlayerManaBar

var current_enemy_id: int
var is_hovering_on_card : bool
var current_absorption: int = 0


#Signals
signal s_damage_enemy(damage:int)
signal s_critical_damage()
signal s_gameover()


func _ready() -> void:
	instance = self
	player_health_bar.max_value = player_hp
	player_mana_bar.max_value = player_mp

	initialize_equipment("init_test")

	#generate_card("standard","bladestorm",1)
	#generate_card("standard","counterspell",6)
	#generate_card("standard","execute",1)
	#generate_card("standard","mana_bomb",1)
	#generate_card("standard","presence_of_mind",1)


func _process(delta) -> void:
	if player_hp + player_hp_regen * delta <= player_hp_max:
		player_hp+= player_hp_regen * delta
	if player_mp + player_mp_regen * delta <= player_mp_max:
		player_mp+= player_mp_regen * delta
	if current_absorption == 0:
		player_health_bar_display.text = str(player_hp)
	else:
		player_health_bar_display.text = str(str(player_hp)," (",str(current_absorption),")")
	player_health_bar.value = player_hp
	player_mana_bar.value = player_mp
	if Input.is_action_just_pressed("ui_accept"):
		#disarm("head")
		inflict_status("standard","crit",5,"player")
		#CardHolder.instance.discard_all()
		#discard(10)
	if Input.is_action_just_pressed("ui_cancel"):
		spawn("test","snake")

func init_status():
	pass

func parse_database(baseName: String, setName: String, parseTarget: String):
	if baseName == "equipment":
		if equipment_database.data[setName][parseTarget] != null:
			return equipment_database.data[setName][parseTarget]
		else:
			print("parse_error on ", baseName, ", ", setName, ", ", parseTarget)
	elif baseName == "entity":
		if entity_database.data[setName][parseTarget] != null:
			return entity_database.data[setName][parseTarget]
		else:
			print("parse_error on ", baseName, ", ", setName, ", ", parseTarget)
	elif baseName == "card":
		if card_database.data[setName][parseTarget] != null:
			return card_database.data[setName][parseTarget]
		else:
			print("parse_error on ", baseName, ", ", setName, ", ", parseTarget)
	elif baseName == "status":
		if status_database.data[setName][parseTarget] != null:
			return status_database.data[setName][parseTarget]
		else:
			print("parse_error on ", baseName, ", ", setName, ", ", parseTarget)
	else:
		print("parse_error")

func generate_card(cardSet: String, cardName: String, amount: int) -> void:
	var script : Script = load(str("res://card_scripts/",cardSet,"/",cardName,".gd"))
	for i in amount:
		var temp = Card.new()
		temp.set_script(script)
		temp.load_data(parse_database("card",cardSet,cardName),cardSet)
		CardHolder.instance.add_card(temp)

func equip(equipSet: String, equipName: String) -> void:
	var temp = Equipment.new()
	temp.set_script(load(str("res://equipment_scripts/",equipSet,"/",equipName,".gd")))
	temp.load_data(parse_database("equipment",equipSet,equipName),equipSet)
	EquipmentHolder.instance.equipToSlot(temp)

func equip_from_equipment(equipment: Equipment) -> void:
	EquipmentHolder.instance.equipToSlot(equipment)

func spawn(entitySet: String, entityName: String) -> void:
	var temp = Entity.new()
	temp.set_script(load(str("res://entity_scripts/",entitySet,"/",entityName,".gd")))
	temp.load_data(parse_database("entity",entitySet,entityName),entitySet)
	EnemyHolder.instance.spawn(temp)


func request_timer(autostart: bool, one_shot: bool, wait_time: float) -> int:
	var temp: Timer = Timer.new()
	temp.autostart = autostart
	temp.one_shot = one_shot
	temp.wait_time = wait_time
	add_child(temp)
	return temp.get_instance_id()

func request_entity_bar(entity: Entity, entity_container: EntityContainer) -> int:
	var temp : EntityBar = preload("res://scene_files/entity_bar.tscn").instantiate()
	temp.set_bar_owner(entity, entity_container)
	$CanvasLayer.add_child(temp)
	return temp.get_instance_id()

func remove_entity_bar(entity_bar_id: int):
	instance_from_id(entity_bar_id).queue_free()


func enter_stage(stageName: String) -> void:
	stage = stageName
	
func generate_loot(entityContainer: EntityContainer, lootContainer:LootContainer):
	lootContainer.load_data()
	lootContainer.position = entityContainer.position
	add_child(lootContainer)

# Effect Function

func damage_enemy(damage: int, can_crit: bool, is_spell: bool) -> bool:
	if is_spell:
		damage+=spell_damage_buff
	if can_crit:
		if randf_range(0,1) <= critical_chance:
			damage*=critical_damage_modifier
			s_critical_damage.emit()
	s_damage_enemy.emit(damage)
	return false

func inflict_status(status_set: String, status_name: String, status_intensity: int, target: String):
	if target == "player":
		if StatusHolder.instance.check_exist_status(status_name):
			print("exists")
			StatusHolder.instance.add_intensity(status_intensity,status_name)
		else:
			print("not_exist")
			var script : Script = load(str("res://status_scripts/",status_set,"/",status_name,".gd"))
			var temp = Status.new()
			temp.set_script(script)
			temp.load_data(parse_database("status",status_set,status_name),status_set)
			temp.target = "player"
			temp.intensity = status_intensity
			StatusHolder.instance.add_status(temp)
	elif target == "enemy":
		pass

func activate(body_part: String):
	EquipmentHolder.instance.activate(body_part)


func discard(amount: int):
	var selection: Array = []
	if amount >= CardHolder.instance.get_card_amount():
		discard_all()
		return

	for i in range(amount):
		var temp = randi_range(0,CardHolder.instance.get_card_amount()-1)
		while selection.find(temp) != -1:
			temp = randi_range(0,CardHolder.instance.get_card_amount()-1)
		selection.append(temp)
	
	selection.sort()
	CardHolder.instance.discard_selected(selection)

func discard_all() -> int:
	var temp = CardHolder.instance.get_card_amount()
	CardHolder.instance.discard_all()
	return temp

func kill_enemy():
	EnemyHolder.instance.kill_current_enemy()

func interrupt():
	pass

func disarm(body_part: String):
	if EquipmentHolder.instance.get_body_part(body_part) != null and EquipmentHolder.instance.get_body_part(body_part).equipment != null:
		var temp_loot : LootContainer = preload("res://scene_files/loot_container.tscn").instantiate()
		temp_loot.equipment = EquipmentHolder.instance.get_body_part(body_part).equipment
		var temp = EntityContainer.new()
		temp.position = Vector3(0,0.2,-0.6)
		generate_loot(temp,temp_loot)
		EquipmentHolder.instance.get_body_part(body_part).equipment.kill_timer()
		EquipmentHolder.instance.get_body_part(body_part).equipment = null


func get_intensity(status: String, target: String) -> int:
	if target == "player":
		return 0
	elif target == "enemy":
		return 0
	return 0

func recover_mana(amount: int):
	player_mp += amount
	if player_mp > player_mp_max:
		player_mp = player_mp_max

func recover_health(amount: int):
	player_hp += amount
	if player_hp > player_hp_max:
		player_hp = player_hp_max

func add_max_mana(amount: int):
	player_mp_max += amount
	player_mp += amount

func add_max_health(amount: int):
	player_hp_max += amount
	player_hp += amount

func damage_player(damage: int, ignore: bool) -> void:
	if !ignore:
		if damage <= current_absorption:
			current_absorption -= damage
		else:
			player_hp -= (damage-current_absorption)
			current_absorption = 0
	elif ignore:
		player_hp -= damage

	if player_hp < 0 :
		player_hp = 0
		s_gameover.emit()

func absorb(amount: int, target: String) -> void:
	if target == "player":
		current_absorption += amount
	elif target == "enemy":
		pass

func initialize_equipment(init_list_name: String) -> void:
	var temp : Array = init_list.data[init_list_name]
	for i in temp:
		equip(i["equipment_set"],i["equipment_name"])
