extends Node

signal gold_changed
signal item_pickedup

var tile_sprites:Array[Resource] = [
	ResourceLoader.load("res://assets/game/images/tile0.png"),
	ResourceLoader.load("res://assets/game/images/tile1.png"),
	ResourceLoader.load("res://assets/game/images/tile2.png"),
	ResourceLoader.load("res://assets/game/images/tile3.png")
]
var item_sprites:Array[Resource] = [
	ResourceLoader.load("res://assets/game/images/item0.png")
]
var tile_stats:Dictionary = {
	0: {
		"is_drillable": true,
		"hp": 1,
		"drop_item": -1,
		"worth": 0,
	},
	1: {
		"is_drillable": true,
		"hp": 2,
		"drop_item": -1,
		"worth": 0,
	},
	2: {
		"is_drillable": false,
		"hp": 99,
		"drop_item": -1,
		"worth": 0,
	},
	3: {
		"is_drillable": true,
		"hp": 4,
		"drop_item": 0,
		"worth": 1,
	}
}
var tile = load("res://assets/game/scenes/tile.tscn")
var friend = load("res://assets/game/scenes/friend.tscn")
var item = load("res://assets/game/scenes/item.tscn")

var save_data: Dictionary = {
	"gold": 0,
	"damage": 1
}
