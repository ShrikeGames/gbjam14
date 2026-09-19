extends RigidBody2D

class_name MoveableTile

@export var tile_id: int = 0
@export var sprite: Sprite2D
@export var animated_sprite: AnimatedSprite2D
@export var hp: float = 2.0
@export var max_hp: float = 2.0
@export var cracks: AnimatedSprite2D
@export var move_speed: float = 64.0
@export var lift_speed: float = 0.0
@export var los_raycast: RayCast2D
@export var los_distance: float = 64.0

var movement: Vector2 = Vector2.ZERO
var direction: int = -1

var iframes: float = 0
var max_iframes: float = 0.3
var being_drilled: bool = false
var sprite_original_position: Vector2
var lifetime: float = 0
var turn_timer:float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_hp = Global.tile_stats[tile_id]["hp"]
	self.hp = max_hp
	if self.move_speed > 0:
		self.sprite_original_position = self.animated_sprite.position
	update_sprite()

func update_sprite():
	if self.sprite:
		self.sprite.texture = Global.tile_sprites[tile_id]

func is_drillable():
	return Global.tile_stats[tile_id]["is_drillable"] and Global.save_data["game"]["damage"] > Global.tile_stats[tile_id]["hardness"]

func _process(delta: float) -> void:
	if move_speed > 0 and self.animated_sprite.animation == "die":
		return
	
	lifetime += delta
	turn_timer += delta
	iframes = clampf(iframes - delta, 0, max_iframes)
	if move_speed > 0 and turn_timer > 3.0:
		self.direction *= -1
		turn_timer = 0
	
	if being_drilled and iframes <= 0 and is_drillable():
		hp -= (Global.save_data["game"]["damage"] - Global.tile_stats[tile_id]["hardness"])
		# 1, 0.75, 0.5, 0.25
		# 4, 3, 2, 1
		cracks.set_frame_and_progress(int(((hp / max_hp) * 4) - 1), 0)
		cracks.visible = true
		iframes = max_iframes
		if hp <= 0:
			if Global.tile_stats[tile_id]["worth"] > 0:
				_create_item(Global.tile_stats[tile_id]["drop_item"], Global.tile_stats[tile_id]["worth"])
			if move_speed > 0:
				self.cracks.visible = false
				self.animated_sprite.play("die")
			else:
				self.get_parent().remove_child(self)
	if move_speed > 0 and self.animated_sprite:
		movement = Vector2.ZERO
		if self.direction < 0:
			self.animated_sprite.scale.x = 1
		else:
			self.animated_sprite.scale.x = -1
		
		
		if direction > 0:
			movement.x += 1
			if los_raycast:
				los_raycast.target_position.x = los_distance
		if direction < 0:
			movement.x -= 1
			if los_raycast:
				los_raycast.target_position.x = - los_distance
		
		if self.animated_sprite.animation != "die":
			if self.animated_sprite.frame > 1:
				movement.y = -1
		
		movement = movement.normalized()
		movement.x *= move_speed
		movement.y *= lift_speed
	
	if los_raycast and los_raycast.is_colliding():
		var body = los_raycast.get_collider()
		if body and (is_instance_of(body, Friend) or is_instance_of(body, Player)):
			self.animated_sprite.play("attack")
			var tile: MoveableTile = Global.moveable_tile.instantiate()
			if direction > 0:
				tile.global_position = self.global_position + Vector2(24, -8)
			elif direction < 0:
				tile.global_position = self.global_position + Vector2(-24, -8)
			tile.tile_id = 5
			self.get_parent().add_child(tile)
			tile.apply_central_force(Vector2(movement.normalized().x * 6028, 0))
			# TODO add sound effect

func _physics_process(_delta: float) -> void:
	if move_speed > 0 and self.animated_sprite.animation == "die":
		return
	self.apply_central_force(movement)

func drill():
	if not is_drillable():
		return
	
	being_drilled = true

func _create_item(item_id: int, worth: int):
	if move_speed > 0 and self.animated_sprite.animation == "die":
		return
	var item: Item = Global.item.instantiate()
	item.position = self.position + Vector2(8, 8)
	item.worth = worth
	item.item_id = item_id
	self.get_parent().call_deferred("add_child", item)

func _on_kill_area_body_entered(body: Node2D) -> void:
	if move_speed > 0 and self.animated_sprite.animation == "die":
		return
	if body and is_instance_of(body, Friend) and not body.dead and body.global_position.y > self.global_position.y + 24 and abs(self.linear_velocity.length()) > 0.1:
		body.hp -= 3
		if body.hp <= 0:
			body.sprite.play("die")
			body.dead = true
			if body and body.arm_container and body.arm_container.get_parent():
				body.arm_container.get_parent().remove_child(body.arm_container)
			Global.friend_died.emit(body)
		else:
			if body.direction > 0:
				self.apply_central_force(Vector2(-1280, 0))
			elif body.direction < 0:
				self.apply_central_force(Vector2(1280, 0))
	if is_instance_of(body, Player) and body.global_position.y > self.global_position.y + 16 and abs(self.linear_velocity.length()) > 0.1:
		Global.player_hurt.emit()
	elif move_speed > 0 and is_instance_of(body, Player):
		Global.player_hurt.emit()
	

func _on_turn_around_area_body_entered(body: Node2D) -> void:
	if move_speed > 0 and self.animated_sprite.animation == "die":
		return
	if move_speed > 0:
		if body and (is_instance_of(body, Tile) or is_instance_of(body, MoveableTile)):
			if self.global_position.x > body.global_position.x:
				self.direction = 1
			elif self.global_position.x <= body.global_position.x:
				self.direction = -1


func _on_sprite_animation_finished() -> void:
	if move_speed > 0 and self.animated_sprite.animation == "die":
		self.get_parent().remove_child(self)
		return
	if self.animated_sprite.animation == "attack":
		self.animated_sprite.play("default")
