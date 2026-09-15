extends MainMenu

@export var day:RichTextLabel
@export var gold_value:RichTextLabel
@export var rent_value:RichTextLabel
@export var food_value:RichTextLabel
@export var heat_value:RichTextLabel
@export var other_label:RichTextLabel
@export var other_value:RichTextLabel
@export var total_value:RichTextLabel
var game_scene:String = "res://assets/game/scenes/game.tscn"
var win_scene:String = "res://assets/game/scenes/win.tscn"

func select_option():
	if selected_id == 0:
		if Global.save_data["gold"] >= 300:
			Global.save_data["gold"] -= 300
			Global.save()
			get_tree().paused = false
			get_tree().change_scene_to_file(win_scene)
		else:
			Global.play_audio_clip(sfx_player, "Beep 7")
		
	if selected_id == 1:
		Global.save_data["hp"] = Global.save_data["max_hp"]
		Global.save()
		get_tree().paused = false
		get_tree().change_scene_to_file(game_scene)
	
func _ready() -> void:
	super._ready()
	Global.load_data()
	if Global.save_data["completed_days"] >= Global.save_data["day"]:
		get_tree().paused = false
		get_tree().change_scene_to_file(game_scene)
		Global.save_data["hp"] = Global.save_data["max_hp"]
		Global.save()
		return
	day.text = "Day %s"%[int(Global.save_data["day"])]
	gold_value.text = "%05d"%[int(Global.save_data["gold"])]
	rent_value.text = "-%02d"%[Global.save_data["rent"]]
	food_value.text = "-%02d"%[Global.save_data["food"]]
	heat_value.text = "-%02d"%[Global.save_data["heat"]]
	other_label.text = "%s"%[Global.save_data["event_name"]]
	
	Global.save_data["gold"] -= Global.save_data["rent"]
	Global.save_data["gold"] -= Global.save_data["food"]
	# Global.save_data["gold"] -= Global.save_data["heat"]
	
	if Global.save_data["event_name"] != "":
		other_value.text = "-%s"%[Global.save_data["event_cost"]]
		Global.save_data["gold"] -= Global.save_data["event_cost"]
	else:
		other_value.text = "%s"%[Global.save_data["event_cost"]]
	
	total_value.text = "%05d"%[int(Global.save_data["gold"])]
	if Global.save_data["gold"] < 0:
		var family:Array[String] = ["mom", "kid", "pet"]
		var alive_family:Array[String] = []
		for f in family:
			if Global.save_data[f] > 0:
				alive_family.append(f)
		var selected_family:String = alive_family.pick_random()
		Global.save_data[selected_family] -= 1
		Global.family_hurt.emit(selected_family, int(Global.save_data[selected_family]))
		
	Global.save_data["gold"] = clampi(Global.save_data["gold"], 0, 99999)
	Global.save_data["hp"] = Global.save_data["max_hp"]
	Global.save_data["event_name"] = ""
	Global.save_data["event_cost"] = ""
	Global.save_data["current_friends"] = 0
	Global.save_data["completed_days"] += 1
	Global.save()
