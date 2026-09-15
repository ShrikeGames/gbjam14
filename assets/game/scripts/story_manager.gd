extends Node2D

#- A long long time ago... the world ended.
#- With no civilization people to returned to...
#- The Good Old Gold Standard
#- You are Riko, a human tasked with leading Molepeople to mine for gold.
#- You must keep you and your family fed and healthy.
#- Then earn enough gold to pay for a trip to live on Mars.
var home_scene:String = "res://assets/game/scenes/home.tscn"

var story:Array = [2.5,
2.0,
4,
3,
2,
5,
2,# GOOD OLD GOLD
3,
3,#food
3,#pay bills
2,#and die
2,
2.5,
3,
2,
2,
4
]
var story_index:int = 0

@export var stories:VBoxContainer
var current_story:StoryText
func _process(_delta: float) -> void:
	if Global.save_data["skip_intro"]:
		get_tree().change_scene_to_file(home_scene)
		return
	if Input.is_action_just_pressed("A") or Input.is_action_just_pressed("B") or Input.is_action_just_pressed("START"):
		get_tree().change_scene_to_file(home_scene)
		return
	
	if story_index >= stories.get_child_count():
		get_tree().change_scene_to_file(home_scene)
		return
	
	current_story = stories.get_child(story_index)
	
	if current_story and not current_story.visible and current_story.hide_timer.is_stopped():
		current_story.visible = true
		current_story.duration_expired.connect(_duration_expired)
		current_story.hide_timer.start(story[story_index])

func _duration_expired():
	current_story.visible = false
	story_index += 1
