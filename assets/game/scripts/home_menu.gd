extends MainMenu

@export var day: RichTextLabel
@export var gold_value: RichTextLabel
@export var rent_value: RichTextLabel
@export var food_value: RichTextLabel
@export var heat_value: RichTextLabel
@export var other_label: RichTextLabel
@export var other_value: RichTextLabel
@export var total_value: RichTextLabel
var game_scene: String = "res://assets/game/scenes/game.tscn"
var win_scene: String = "res://assets/game/scenes/win.tscn"

func select_option():
	if selected_id == 0:
		if Global.save_data["game"]["gold"] >= 150:
			Global.save_data["game"]["gold"] -= 150
			get_tree().paused = false
			get_tree().change_scene_to_file(win_scene)
		else:
			Global.play_audio_clip(sfx_player, "Beep 7")
		
	if selected_id == 1:
		Global.save_data["game"]["hp"] = Global.save_data["game"]["max_hp"]
		get_tree().paused = false
		get_tree().change_scene_to_file(game_scene)
	
func _ready() -> void:
	super._ready()
	Global.save()
	day.text = tr("UI_DAY") % [int(Global.save_data["game"]["day"])]
	gold_value.text = "%05d" % [int(Global.save_data["game"]["gold"])]
	rent_value.text = "-%02d" % [Global.save_data["game"]["rent"] + (Global.save_data["game"]["completed_days"])]
	food_value.text = "-%02d" % [Global.save_data["game"]["food"] + (Global.save_data["game"]["completed_days"])]
	heat_value.text = "-%02d" % [Global.save_data["game"]["heat"] + (Global.save_data["game"]["completed_days"])]
	other_label.text = tr(Global.save_data["game"]["event_name"])
	
	Global.save_data["game"]["gold"] -= Global.save_data["game"]["rent"] + (Global.save_data["game"]["completed_days"])
	Global.save_data["game"]["gold"] -= Global.save_data["game"]["food"] + (Global.save_data["game"]["completed_days"])
	# Global.save_data["game"]["gold"] -= Global.save_data["game"]["heat"]
	
	if Global.save_data["game"]["event_name"] != "":
		other_value.text = "-%s" % [Global.save_data["game"]["event_cost"]]
		Global.save_data["game"]["gold"] -= Global.save_data["game"]["event_cost"]
	else:
		other_value.text = "%s" % [Global.save_data["game"]["event_cost"]]
	
	total_value.text = "%05d" % [int(Global.save_data["game"]["gold"])]
	if Global.save_data["game"]["gold"] < 0:
		var family: Array[String] = ["mom", "kid", "pet"]
		var alive_family: Array[String] = []
		for f in family:
			if Global.save_data["game"][f] > 0:
				alive_family.append(f)
		if len(alive_family) > 0:
			var selected_family: String = alive_family.pick_random()
			Global.save_data["game"][selected_family] -= 1
			Global.family_hurt.emit(selected_family, int(Global.save_data["game"][selected_family]))
		
	Global.save_data["game"]["gold"] = clampi(Global.save_data["game"]["gold"], 0, 99999)
	Global.save_data["game"]["hp"] = Global.save_data["game"]["max_hp"]
	Global.save_data["game"]["event_name"] = ""
	Global.save_data["game"]["event_cost"] = ""
	Global.save_data["game"]["current_friends"] = 0
	Global.save_data["game"]["completed_days"] += 1
