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
@export var sfx_player:AudioStreamPlayer2D
@export var eyes:Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drill1.max_move_depth = 4.0
	drill2.max_move_depth = 4.0
	drill1.cannot_drill.connect(_cannot_drill)
	drill2.cannot_drill.connect(_cannot_drill)
	
	var audio_stream_player_stream = preload("res://assets/game/audio/sfx_interactive_stream.tres")
	sfx_player.stream = audio_stream_player_stream
	sfx_player.play()
	
	
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
	
	if eyes:
		for eye in eyes:
			if Global.enable_rotation:
				eye.look_at(drill.global_position)
			else:
				if direction > 0:
					eye.rotation_degrees = 0
				else:
					eye.rotation_degrees = -180
				


func _physics_process(_delta: float) -> void:
	self.apply_central_force(movement)

func _on_collect_area_body_entered(body: Node2D) -> void:
	if not is_instance_of(body, Item):
		return
	if is_instance_of(body, Item):
		worth += body.worth
		Global.play_audio_clip(sfx_player, "Beep 3")
		body.get_parent().remove_child(body)

func _on_body_entered(_body: Node) -> void:
	Global.play_audio_clip(sfx_player, "Beep 0")
