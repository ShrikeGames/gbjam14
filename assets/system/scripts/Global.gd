extends Node

signal gold_changed
signal item_pickedup
signal recall_friends
signal add_friend
signal cannot_afford
signal friend_got_item
signal friend_died
signal shop_open
signal shop_close
signal player_hurt
signal player_max_health_increase
signal player_died
signal family_hurt

var enable_rotation:bool = true

var save_file_location: String = "user://save_data_v1.json"

var tile_sprites:Array[Resource] = [
	ResourceLoader.load("res://assets/game/images/tile0.png"),
	ResourceLoader.load("res://assets/game/images/tile1.png"),
	ResourceLoader.load("res://assets/game/images/tile2.png"),
	ResourceLoader.load("res://assets/game/images/tile3.png"),
	ResourceLoader.load("res://assets/game/images/tile4.png"),
	ResourceLoader.load("res://assets/game/images/tile5.png"),
	ResourceLoader.load("res://assets/game/images/tile0.png"),
	ResourceLoader.load("res://assets/game/images/tile0.png"),
	ResourceLoader.load("res://assets/game/images/tile0.png"),
	ResourceLoader.load("res://assets/game/images/tile9.png")
]
var item_sprites:Array[Resource] = [
	ResourceLoader.load("res://assets/game/images/item0.png"),
	ResourceLoader.load("res://assets/game/images/item1.png"),
	
]
var tile_stats:Dictionary = {
	0: {
		"is_drillable": true,
		"hp": 1,
		"hardness": 0,
		"drop_item": -1,
		"worth": 0,
	},
	1: {
		"is_drillable": true,
		"hp": 4,
		"hardness": 0,
		"drop_item": -1,
		"worth": 0,
	},
	2: {
		"is_drillable": true,
		"hp": 10,
		"hardness": 6,
		"drop_item": -1,
		"worth": 0,
	},
	
	3: {
		"is_drillable": true,
		"hp": 6,
		"hardness": 0,
		"drop_item": 0,
		"worth": 1,
	},
	4: {
		"is_drillable": true,
		"hp": 12,
		"hardness": 2,
		"drop_item": 0,
		"worth": 5,
	},
	5: {
		"is_drillable": true,
		"hp": 10,
		"hardness": 4,
		"drop_item": -1,
		"worth": 0,
	},
	9: {
		"is_drillable": false,
		"hp": 99,
		"hardness": 99,
		"drop_item": -1,
		"worth": 0,
	},
}
var tile = load("res://assets/game/scenes/tile.tscn")
var moveable_tile = load("res://assets/game/scenes/moveabletile.tscn")
var friend = load("res://assets/game/scenes/friend.tscn")
var item = load("res://assets/game/scenes/item.tscn")
var heart = load("res://assets/game/scenes/heart.tscn")

func play_audio_clip(audio_player, clip_name:String):
	var playback = audio_player.get_stream_playback() as AudioStreamPlaybackInteractive
	audio_player.pitch_scale = randf_range(0.5, 1.5)
	playback.switch_to_clip_by_name(clip_name)


var DEFAULT_SAVE_DATA:Dictionary = {
	"day": 1,
	"completed_days": 0,
	"rent": 5,
	"food": 5,
	"heat": 2,
	"event_cost": "",
	"event_name": "",
	"started": false,
	"skip_intro": false,
	"gold": 10,
	"damage": 1,
	"current_friends": 0,
	"max_friends": 2,
	"hp": 4,
	"max_hp": 4,
	"prices": [
		1,
		5,
		10,
		300
	],
	"mom": 2,
	"kid": 2,
	"pet": 2
}
var save_data:Dictionary = DEFAULT_SAVE_DATA.duplicate(true)

func read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var json_string = FileAccess.get_file_as_string(path)
	var json_dict = JSON.parse_string(json_string)
	
	return json_dict

func save() -> void:
	save_data["started"] = true
	var json_string := JSON.stringify(save_data)
	var file_access := FileAccess.open(save_file_location, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
	file_access.store_line(json_string)
	file_access.close()

func load_data() -> void:
	var saved_json: Dictionary = read_json(save_file_location)
	if not saved_json.is_empty():
		saved_json["current_friends"] = 0
		save_data = saved_json
	
func _ready() -> void:
	load_data()
	
