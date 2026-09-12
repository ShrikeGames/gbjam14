extends RigidBody2D

class_name Item

@export var item_id:int = 0
@export var worth:int = 1
@export var sprite:Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_sprite()

func update_sprite():
	self.sprite.texture = Global.item_sprites[item_id]

func pickup_item():
	Global.item_pickedup.emit(self)
