extends Node2D
class_name Drill
signal cannot_drill

@export var curve:Curve

var original_position:Vector2
var drill_state:float = 0.0
var drill_move_speed:float = 0.1
var max_move_depth:float = 12.0
var is_drilling:bool = false
@export var drill_direction:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = self.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_drilling:
		drill_state=clampf(drill_state+drill_move_speed, 0, 1.0)
	else:
		drill_state=clampf(drill_state-drill_move_speed, 0, 1.0)
	if drill_direction == 0:
		self.position.y = self.original_position.y + curve.sample(drill_state) * max_move_depth
	if drill_direction > 0:
		self.position.x = self.original_position.x + curve.sample(drill_state) * max_move_depth
	if drill_direction < 0:
		self.position.x = self.original_position.x - curve.sample(drill_state) * max_move_depth
	
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
