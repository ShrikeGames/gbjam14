extends RigidBody2D
class_name Player
signal friend_count_changed

@export var move_speed: int = 64
@export var lift_speed: int = 128
@export var right_speed: float = 25.0
@export var drill: Drill
@export var friends_container: Node2D
@export var sprite: AnimatedSprite2D
var sprite_original_position: Vector2
var lifetime: float = 0.0

@export var sfx_player: AudioStreamPlayer
@export var portrait: AnimatedSprite2D

var movement: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var audio_stream_player_stream = preload("res://assets/game/audio/sfx_interactive_stream.tres")
	sfx_player.stream = audio_stream_player_stream
	sfx_player.play()
	
	Global.recall_friends.connect(_recall_friends)
	Global.add_friend.connect(_add_friend)
	self.sprite_original_position = sprite.position
	
func _add_friend():
	Global.save_data["game"]["max_friends"] += 1
	friend_count_changed.emit(Global.save_data["game"]["current_friends"], Global.save_data["game"]["max_friends"], 1)
	
func _process(delta: float) -> void:
	lifetime += delta
	movement = Vector2.ZERO
	
	if Input.is_action_pressed("RIGHT"):
		movement.x += move_speed
	if Input.is_action_pressed("LEFT"):
		movement.x -= move_speed
	if Input.is_action_pressed("UP"):
		movement.y -= lift_speed
	if Input.is_action_just_pressed("DOWN"):
		drill.drill_down()
		Global.play_audio_clip(sfx_player, "Beep 5")
	if Input.is_action_just_released("DOWN"):
		drill.stop_drill()
	if Input.is_action_just_pressed("A"):
		# spawn pointing right
		self._spawn_friend(1)
	if Input.is_action_just_pressed("B"):
		# spawn pointing left
		self._spawn_friend(-1)
	movement = movement.normalized()
	movement.x *= move_speed
	movement.y *= lift_speed
	
	sprite.position = sprite_original_position + Vector2(0, sin(lifetime * 4) * 2)

func _physics_process(_delta: float) -> void:
	self.apply_central_force(movement)

func _spawn_friend(direction: int = 1):
	if Global.save_data["game"]["current_friends"] < Global.save_data["game"]["max_friends"]:
		Global.save_data["game"]["current_friends"] += 1
		friend_count_changed.emit(Global.save_data["game"]["current_friends"], Global.save_data["game"]["max_friends"], -1)
	else:
		return
	
	
	var friend: Friend = Global.friend.instantiate()
	friend.global_position = self.global_position - Vector2(0, 8.0)
	friend.direction = direction
	friends_container.add_child(friend)

func _recall_friends():
	for friend in friends_container.get_children():
		if is_instance_of(friend, Friend) and not friend.dead:
			_recall_friend(friend)

func _recall_friend(friend: Friend):
	if friend.dead:
		return
	portrait.play("happy")
	Global.play_audio_clip(sfx_player, "Player Happy")
	if friend.worth > 0:
		Global.play_audio_clip(sfx_player, "Beep 8")
		Global.save_data["game"]["gold"] += friend.worth
		Global.save_data["game"]["total_gold"] += friend.worth
		Global.gold_changed.emit(Global.save_data["game"]["gold"], friend.worth)
	if friend.hearts_count > 0:
		Global.save_data["game"]["max_hp"] = min(Global.save_data["game"]["max_hp"] + 2 * (friend.hearts_count), 14)
		Global.save_data["game"]["hp"] = Global.save_data["game"]["max_hp"]
		Global.player_max_health_increase.emit()
	
	friend.get_parent().remove_child(friend)
	Global.save_data["game"]["current_friends"] -= 1
	friend_count_changed.emit(Global.save_data["game"]["current_friends"], Global.save_data["game"]["max_friends"], 1)

func _on_collection_area_body_entered(body: Node2D) -> void:
	if not is_instance_of(body, Friend) and not is_instance_of(body, Item):
		return
	if is_instance_of(body, Friend) and body.lifetime >= 3.0:
		_recall_friend(body)
	if is_instance_of(body, Item):
		Global.play_audio_clip(sfx_player, "Beep 5")
		if body.worth > 0:
			Global.save_data["game"]["gold"] += body.worth
			Global.save_data["game"]["total_gold"] += body.worth
			Global.gold_changed.emit(Global.save_data["game"]["gold"], body.worth)
		if body.item_id == 1:
			# heart
			Global.save_data["game"]["max_hp"] = min(Global.save_data["game"]["max_hp"] + 2, 14)
			Global.save_data["game"]["hp"] = Global.save_data["game"]["max_hp"]
			Global.player_max_health_increase.emit()
		portrait.play("happy")
		Global.play_audio_clip(sfx_player, "Player Happy")
		body.get_parent().remove_child(body)

func _on_body_entered(_body: Node) -> void:
	Global.play_audio_clip(sfx_player, "Beep 0")
