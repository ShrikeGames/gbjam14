extends RigidBody2D
class_name Player
signal friend_count_changed

@export var move_speed:int = 64
@export var lift_speed:int = 128
@export var right_speed:float = 25.0
@export var drill:Drill
@export var friends_container:Node2D
@export var max_friends:int = 2
var current_friends:int = 0

var movement:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func _process(_delta: float) -> void:
	movement = Vector2.ZERO
	
	if Input.is_action_pressed("RIGHT"):
		movement.x += move_speed
	if Input.is_action_pressed("LEFT"):
		movement.x -= move_speed
	if Input.is_action_pressed("UP"):
		movement.y -= lift_speed
	if Input.is_action_just_pressed("DOWN"):
		drill.drill_down()
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
	

func _physics_process(_delta: float) -> void:
	self.apply_central_force(movement)

func _spawn_friend(direction:int = 1):
	if current_friends < max_friends:
		current_friends += 1
		friend_count_changed.emit(current_friends, max_friends, -1)
	else:
		return
	
	var friend:Friend = Global.friend.instantiate()
	friend.position = self.global_position
	friend.direction = direction
	friends_container.add_child(friend)



func _on_collection_area_body_entered(body: Node2D) -> void:
	if not is_instance_of(body, Friend) and not is_instance_of(body, Item):
		return
	if is_instance_of(body, Friend) and body.lifetime >= 3.0:
		if body.worth > 0:
			Global.save_data["gold"] += body.worth
			Global.gold_changed.emit(Global.save_data["gold"], body.worth)
		body.get_parent().remove_child(body)
		current_friends -= 1
		friend_count_changed.emit(current_friends, max_friends, 1)
	if is_instance_of(body, Item):
		Global.save_data["gold"] += body.worth
		Global.gold_changed.emit(Global.save_data["gold"], body.worth)
		body.get_parent().remove_child(body)
