extends RigidBody2D

class_name Item

@export var item_id:int = 0
@export var worth:int = 1
@export var sprite:Sprite2D
var sprite_original_position:Vector2
var lifetime:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_original_position = sprite.position
	update_sprite()

func _process(delta: float) -> void:
	lifetime += delta
	sprite.position = sprite_original_position + Vector2(0, sin(lifetime*4)*2)

func update_sprite():
	self.sprite.texture = Global.item_sprites[item_id]

func pickup_item():
	Global.item_pickedup.emit(self)
