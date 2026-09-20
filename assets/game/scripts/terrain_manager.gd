extends Node2D


@export var map_width:int = 64
@export var map_height:int = 112
@export var tile_width:int = 16
@export var tile_height:int = 16
@export var zone_height:float = 16.0
@export var sfx_player:AudioStreamPlayer
var tiles_by_depth:Array[Array]=[
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,3,3,3,2,3,4,5],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,4,3,0,0,0,0,0,0,5,6],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,0,0,2,4,4,3,3,0,0,0,0,0,5,6,7],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,2,3,0,0,0,1,1,5,6,7],
	[1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,1,1,1,1,1,4,4,4,4,4,4,4,4,4,4,4,4,4,0,0,0,5,6,7],
	[1,3,4,4,4,4,4,2,5,0,6,7],
	[1,3,4,4,4,4,4,2,5,0,6,7],
	[1,3,4,4,4,4,4,2,5,0,6,7]
]

# 0 empty
# 1 dirt
# 2 hard to destroy
# 3 gold
# 4 is big gold
# 5 is moveabletile boulder
# 9 is indestructable
# 

var heart_items_added:Array[int] = [0,0,0,0,0,0,0,0]

func _ready() -> void:
	var audio_stream_player_stream = preload("res://assets/game/audio/sfx_interactive_stream.tres")
	sfx_player.stream = audio_stream_player_stream
	sfx_player.play()
	
	var tile_type:int = 0
	for y in range(0, map_height):
		for x in range(0, map_width):
			
			if y == 6 and x > 8 and x < 19:
				tile_type = 2
				_create_tile(x*tile_width, y*tile_height, tile_type)
				continue
				
			if y > 6 and randf()<=0.001*x and heart_items_added[int(y/zone_height)] < 1:
				var heart_item:Item = Global.item.instantiate()
				heart_item.item_id = 1
				heart_item.position = Vector2(x*tile_width, y*tile_height)
				self.add_child(heart_item)
				heart_items_added[int(y/zone_height)] += 1
				continue
			
			if y == 0 or x == 0 or y == map_height-1 or x ==  map_width -1:
				tile_type = 9
				_create_tile(x*tile_width, y*tile_height, tile_type)
			elif y > 5:
				var tiles:Array = tiles_by_depth[int(y/zone_height)]
				tile_type = tiles.pick_random()
				if tile_type != 0:
					_create_tile(x*tile_width, y*tile_height, tile_type)

func _create_tile(x:int, y:int, tile_type:int) -> void:
	if tile_type == 0:
		return
	if tile_type == 5:
		var tile:MoveableTile = Global.moveable_tile.instantiate()
		tile.position = Vector2(x,y)
		tile.tile_id = tile_type
		tile.sfx_player = sfx_player
		self.add_child(tile)
	elif tile_type == 6:
		var tile:MoveableTile = Global.enemy0.instantiate()
		tile.position = Vector2(x,y)
		tile.tile_id = tile_type
		tile.sfx_player = sfx_player
		self.add_child(tile)
	elif tile_type == 7:
		var tile:MoveableTile = Global.enemy1.instantiate()
		tile.position = Vector2(x,y)
		tile.tile_id = tile_type
		tile.sfx_player = sfx_player
		self.add_child(tile)
	else:
		var tile:Tile = Global.tile.instantiate()
		tile.position = Vector2(x,y)
		tile.tile_id = tile_type
		self.add_child(tile)
	
