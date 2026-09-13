extends Node2D
class_name FriendDrill
signal cannot_drill

@export var curve:Curve

var drill_state:float = 0.0
var drill_move_speed:float = 1.0
var max_move_depth:float = 90.0
var is_drilling:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_drilling:
		drill_state=clampf(drill_state+drill_move_speed, 0, 1.0)
	else:
		drill_state=clampf(drill_state-drill_move_speed, 0, 1.0)
	
func drill_down():
	is_drilling = true

func stop_drill():
	is_drilling = false


func _on_drill_area_body_entered(tile: Node2D) -> void:
	if not is_instance_of(tile, Tile):
		return
	if is_drilling:
		if tile.is_drillable():
			tile.drill()
		else:
			is_drilling = false
			cannot_drill.emit(tile)
	


func _on_drill_area_body_exited(tile: Node2D) -> void:
	if not is_instance_of(tile, Tile):
		return
	tile.being_drilled = false
