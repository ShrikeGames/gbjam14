extends Sprite2D

@export var max_distance_x:int = 2
@export var max_distance_y:int = 4
var lifetime:float = randf()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position += Vector2(randi_range(-max_distance_x, max_distance_x), randi_range(-max_distance_y, max_distance_y))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime += delta
	self.scale = Vector2(abs(sin(lifetime)), abs(sin(lifetime)))
