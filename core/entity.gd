class_name Entity

var entity_set: String
var entity_name: String
var entity_display_name: String
var max_health: int
var current_health: int
var entity_data: Dictionary
var entity_resource: CompressedTexture2D

var timer_id: int
var entity_bar_id: int
var countdown: float
var is_paused: bool = true

#Default asset
var entity_back_resource: CompressedTexture2D = preload("res://assets/general/entity_card_back.png")
var entity_frame_resource: CompressedTexture2D = preload("res://assets/general/entity_card_frame.png")
var entity_label_resource: CompressedTexture2D = preload("res://assets/general/entity_card_label.png")

var loot_rate : float
var loot_pool : Array
var loot_list: Array = []
var status_list : Array[Status] = []
var intent_cycle: IntentCycle = IntentCycle.new([Intent.new()]);

func load_data(data: Dictionary,entitySet: String) -> void:
	entity_data = data
	entity_set = entitySet
	entity_name = data["entity_name"]
	entity_display_name = data["entity_display_name"]
	max_health = data["health"]
	loot_list = data["loot_list"]
	loot_rate = data["loot_rate"]
	loot_pool = preload("res://data/loot_pool_data.json").data[data["loot_pool"]]
	print(loot_list)
	print(loot_pool)
	current_health = max_health
	entity_resource = load(str("res://assets/entity/", entity_set, "/",data["entity_resource"]))

func _set_property() -> void:
	pass

func _on_entity_spawn() -> void:
	init_timer()
	GameManager.instance.s_damage_enemy.connect(damaged)

func _init() -> void:
	countdown = intent_cycle.cycle_list[0].intent_wait_time


func init_timer() -> void:
	timer_id = GameManager.instance.request_timer(true,false,countdown)
	instance_from_id(timer_id).timeout.connect(_on_timeout)

func get_remaining_time() -> float:
	return instance_from_id(timer_id).time_left

func _on_entity_died(entity_container: EntityContainer) -> void:
	var temp_loot = check_loot_list()
	GameManager.instance.generate_loot(entity_container,temp_loot)

func pack_loot(equipment_set : String, equipment_name : String) -> LootContainer:
	var temp_equipment = Equipment.new()
	temp_equipment.set_script(load(str("res://equipment_scripts/",equipment_set,"/",equipment_name,".gd")))
	temp_equipment.load_data(GameManager.instance.parse_database("equipment",equipment_set,equipment_name),equipment_set)
	var temp_loot : LootContainer = preload("res://scene_files/loot_container.tscn").instantiate()
	temp_loot.equipment = temp_equipment
	print(temp_loot.equipment.equipment_name)
	print("generate_loot")
	return temp_loot

func check_loot_list():
	var temp = randf_range(0.0,1.0)
	print(temp)
	if temp <= loot_rate:
		#print("loot_from_list")
		return loot_from_list()
	else:
		return loot_from_pool()

func loot_from_list():
	var total_chance = 0
	for i in loot_list:
		total_chance += i["drop_rate"]
	var temp = randi_range(0,total_chance)
	for i in loot_list:
		temp -= i["drop_rate"]
		if temp<=0:
			return pack_loot(i["equipment_set"],i["equipment_name"])


func loot_from_pool():
	var temp = randi_range(0,loot_pool.size()-1)
	return pack_loot(loot_pool[temp]["equipment_set"],loot_pool[temp]["equipment_name"])



func _on_timeout() -> void:
	instance_from_id(timer_id).start(intent_cycle.cycle())
	instance_from_id(entity_bar_id).update_tooltip(intent_cycle.get_current_intent())

func damaged(damage: int) -> void:
	current_health = current_health - damage

func update_display_health() -> void:
	instance_from_id(entity_bar_id).HealthBar.max_value = max_health
	instance_from_id(entity_bar_id).HealthBar.value = current_health

func update_display_timer() -> void:
	instance_from_id(entity_bar_id).Action.max_value = countdown
	instance_from_id(entity_bar_id).Action.value = get_remaining_time()
