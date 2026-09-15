extends CenterContainer

var home_scene:String = "res://assets/game/scenes/home.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_hurt.connect(_player_hurt)
	Global.player_max_health_increase.connect(_player_max_health_increase)
	for i in range(0,Global.save_data["max_hp"]/2):
		var heart:Heart = Global.heart.instantiate()
		heart.position = Vector2(8 + i * 16, 8)
		self.add_child(heart)
	update()

func _process(_delta: float) -> void:
	if Global.save_data["hp"] <= 0:
		Global.save_data["event_name"] = "Hospital"
		Global.save_data["event_cost"] = 10
		Global.save_data["hp"] = Global.save_data["max_hp"]
		Global.save()
		get_tree().change_scene_to_file(home_scene)
	
func update():
	var target_hp:int = Global.save_data["max_hp"]
	var hearts:Array = self.get_children()
	hearts.reverse()
	for heart:Heart in hearts:
		var target_frame:int = clampi((target_hp - Global.save_data["hp"]), 0, 2)
		heart.play("%s"%[target_frame])
		target_hp -= 2
	
func _player_hurt():
	Global.save_data["hp"] = clampi(Global.save_data["hp"]-1, 0, Global.save_data["max_hp"])
	update()

func _player_max_health_increase():
	var heart:Heart = Global.heart.instantiate()
	heart.position = Vector2(8 + ((Global.save_data["max_hp"]/2)-1) * 16, 8)
	self.add_child(heart)
	update()
