extends RigidBody2D

class_name Friend

var direction:int = 1
var move_speed:float = 48
var lift_speed:float = 0.0
var movement:Vector2 = Vector2.ZERO
var drill:Drill
@export var drill1:Drill
@export var drill2:Drill
var lifetime:float = 0.0
var worth:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drill1.max_move_depth = 6.0
	drill2.max_move_depth = 6.0
	drill1.cannot_drill.connect(_cannot_drill)
	drill2.cannot_drill.connect(_cannot_drill)
	
func _cannot_drill(_tile:Tile):
	drill1.stop_drill()
	drill2.stop_drill()
	
	self.direction *= -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime += delta
	movement = Vector2.ZERO
	if self.direction < 0:
		drill = drill2
	else:
		drill = drill1
	
	drill.drill_down()
	if direction > 0:
		movement.x += 1
	if direction < 0:
		movement.x -= 1
	movement.y = -1
	
	movement = movement.normalized()
	movement.x *= move_speed
	movement.y *= lift_speed
	
	

func _physics_process(_delta: float) -> void:
	self.apply_central_force(movement)


func _on_collect_area_body_entered(body: Node2D) -> void:
	if not is_instance_of(body, Item):
		return
	if is_instance_of(body, Item):
		worth += body.worth
		body.get_parent().remove_child(body)
