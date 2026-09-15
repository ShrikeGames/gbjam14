extends RigidBody2D

class_name MoveableTile

@export var tile_id:int = 0
@export var sprite:Sprite2D
@export var hp:float = 2.0
@export var max_hp:float = 2.0
@export var cracks:AnimatedSprite2D

var iframes:float = 0
var max_iframes:float = 0.3
var being_drilled:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_hp = Global.tile_stats[tile_id]["hp"]
	self.hp = max_hp
	update_sprite()

func update_sprite():
	self.sprite.texture = Global.tile_sprites[tile_id]

func is_drillable():
	return Global.tile_stats[tile_id]["is_drillable"] and Global.save_data["damage"] > Global.tile_stats[tile_id]["hardness"]

func _process(delta: float) -> void:
	iframes = clampf(iframes-delta, 0, max_iframes)
	if being_drilled and iframes <= 0 and is_drillable():
		hp -= (Global.save_data["damage"] - Global.tile_stats[tile_id]["hardness"])
		# 1, 0.75, 0.5, 0.25
		# 4, 3, 2, 1
		cracks.set_frame_and_progress(int(((hp/max_hp)*4)-1),0)
		cracks.visible = true
		iframes = max_iframes
		if hp <= 0:
			if Global.tile_stats[tile_id]["worth"] > 0:
				_create_item(Global.tile_stats[tile_id]["drop_item"], Global.tile_stats[tile_id]["worth"])
			self.get_parent().remove_child(self)
	

func drill():
	if not is_drillable():
		return
	
	being_drilled = true
	

func _create_item(item_id:int, worth:int):
	var item:Item = Global.item.instantiate()
	item.position = self.position + Vector2(8,8)
	item.worth = worth
	item.item_id = item_id
	self.get_parent().call_deferred("add_child", item)


func _on_kill_area_body_entered(body: Node2D) -> void:
	if body and is_instance_of(body, Friend) and not body.dead and body.global_position.y > self.global_position.y+24 and abs(self.linear_velocity.length()) > 0.1 :
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
	if is_instance_of(body, Player) and body.global_position.y > self.global_position.y+16 and abs(self.linear_velocity.length()) > 0.1 :
		Global.player_hurt.emit()
	
