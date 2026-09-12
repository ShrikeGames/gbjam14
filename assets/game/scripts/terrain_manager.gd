extends Node2D


@export var map_width:int = 100
@export var map_height:int = 90
@export var tile_width:int = 16
@export var tile_height:int = 16
var tiles_by_depth:Array[Array]=[
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,3],
	[1,1,1,1,1,1,1,1,1,2,2,4,3,0,0,0,0],
	[1,1,1,1,1,1,1,2,2,2,4,4,3,3,3,2,2],
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile_type:int = 0
	for y in range(0, map_height):
		for x in range(0, map_width):
			
			if y == 10 and x > 6 and x < 17:
				tile_type = 2
				_create_tile(x*tile_width, y*tile_height, tile_type)
				continue
			
			if y == 0 or x == 0 or y == map_height-1 or x ==  map_width -1:
				tile_type = 2
				_create_tile(x*tile_width, y*tile_height, tile_type)
			elif y > map_height * 0.1:
				var tiles:Array = tiles_by_depth[int(y/32.0)]
				tile_type = tiles.pick_random()
				if tile_type != 0:
					_create_tile(x*tile_width, y*tile_height, tile_type)
			
				

func _create_tile(x:int, y:int, tile_type:int) -> void:
	var tile:Tile = Global.tile.instantiate()
	tile.position = Vector2(x,y)
	tile.tile_id = tile_type
	self.add_child(tile)
