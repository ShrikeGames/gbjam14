extends RigidBody2D

class_name Friend

var direction:int = 1
var move_speed:float = 48
var lift_speed:float = 0.0
var movement:Vector2 = Vector2.ZERO
@export var drill:FriendDrill
var lifetime:float = 0.0
var worth:int = 0
@export var sfx_player:AudioStreamPlayer2D
@export var sprite:AnimatedSprite2D
@export var arm:LegSegment
@export var arm_container:Node2D


var dead:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drill.cannot_drill.connect(_cannot_drill)
	
	var audio_stream_player_stream = preload("res://assets/game/audio/sfx_interactive_stream.tres")
	sfx_player.stream = audio_stream_player_stream
	sfx_player.play()
	
	
func _cannot_drill(_tile:Tile):
	if dead:
		return
	drill.stop_drill()
	self.direction *= -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dead:
		return
	lifetime += delta
	movement = Vector2.ZERO
	if self.direction < 0:
		self.sprite.scale.x = 1
		self.arm.scale.x = 1
	else:
		self.sprite.scale.x = -1
		self.arm.scale.x = -1
	
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
	if dead:
		return
	self.apply_central_force(movement)

func _on_collect_area_body_entered(body: Node2D) -> void:
	if dead:
		return
	if not is_instance_of(body, Item):
		return
	if is_instance_of(body, Item):
		Global.friend_got_item.emit()
		worth += body.worth
		Global.play_audio_clip(sfx_player, "Beep 3")
		body.get_parent().remove_child(body)

func _on_body_entered(_body: Node) -> void:
	if dead:
		return
	Global.play_audio_clip(sfx_player, "Beep 0")


func _on_friend_animated_sprite_animation_finished() -> void:
	if sprite.animation == "die":
		dead = true
