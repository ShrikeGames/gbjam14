extends RayCast2D
class_name GBRayCast2D

var original_rotation:float
var lifetime:float = 0.0
var max_degrees:float = 45.0
@export var tip:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.original_rotation = self.rotation_degrees


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime += delta * 2.0
	self.rotation_degrees = self.original_rotation - sin(lifetime) * max_degrees
