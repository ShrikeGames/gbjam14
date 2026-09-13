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

var enable_rotation:bool = true

var tile_sprites:Array[Resource] = [
	ResourceLoader.load("res://assets/game/images/tile0.png"),
	ResourceLoader.load("res://assets/game/images/tile1.png"),
	ResourceLoader.load("res://assets/game/images/tile2.png"),
	ResourceLoader.load("res://assets/game/images/tile3.png"),
	ResourceLoader.load("res://assets/game/images/tile4.png")
]
var item_sprites:Array[Resource] = [
	ResourceLoader.load("res://assets/game/images/item0.png")
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
		"hp": 2,
		"hardness": 0,
		"drop_item": -1,
		"worth": 0,
	},
	2: {
		"is_drillable": true,
		"hp": 10,
		"hardness": 4,
		"drop_item": -1,
		"worth": 0,
	},
	
	3: {
		"is_drillable": true,
		"hp": 4,
		"hardness": 0,
		"drop_item": 0,
		"worth": 1,
	},
	4: {
		"is_drillable": true,
		"hp": 8,
		"hardness": 1,
		"drop_item": 0,
		"worth": 10,
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
var friend = load("res://assets/game/scenes/friend.tscn")
var item = load("res://assets/game/scenes/item.tscn")

var save_data: Dictionary = {
	"gold": 0,
	"damage": 1
}


func play_audio_clip(audio_player, clip_name:String):
	var playback = audio_player.get_stream_playback() as AudioStreamPlaybackInteractive
	audio_player.pitch_scale = randf_range(0.5, 1.5)
	playback.switch_to_clip_by_name(clip_name)
