extends RichTextLabel
class_name StoryText

signal duration_expired

@export var hide_timer:Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false

func _on_hide_timer_timeout() -> void:
	self.visible = false
	duration_expired.emit()
