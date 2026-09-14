extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.family_hurt.connect(_family_hurt)
	_family_hurt("mom", Global.save_data["mom"])
	_family_hurt("kid", Global.save_data["kid"])
	_family_hurt("pet", Global.save_data["pet"])

func _family_hurt(family_member_name:String, health:int):
	var animation:String = "default"
	if health == 1:
		animation = "sad"
	elif health == 0:
		animation = "dead"
	
	self.find_child(family_member_name).play(animation)
	
