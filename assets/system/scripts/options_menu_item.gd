extends GBMenuItem

class_name GBOptionsMenuItem

@export var sprite_frames:SpriteFrames
@export var toggle_sprite:AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	toggle_sprite.sprite_frames = sprite_frames

	
