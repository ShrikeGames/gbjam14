extends CenterContainer

class_name WinScreen

@export var gold_total:RichTextLabel
@export var mom_status:RichTextLabel
@export var kid_status:RichTextLabel
@export var pet_status:RichTextLabel
@export var days_count:RichTextLabel
@export var total_score_value:RichTextLabel
@export var ranking:RichTextLabel
@export var ranking_description:RichTextLabel

var statuses:Array[String] = [tr("WIN_STATUS_DEAD"), tr("WIN_STATUS_SICK"), tr("WIN_STATUS_ALIVE")]

func _ready() -> void:
	gold_total.text = "%5d"%[Global.save_data["total_gold"]]
	mom_status.text = "%s"%[statuses[Global.save_data["mom"]]]
	kid_status.text = "%s"%[statuses[Global.save_data["kid"]]]
	pet_status.text = "%s"%[statuses[Global.save_data["pet"]]]
	days_count.text = "%2d"%[Global.save_data["completed_days"]]
	
	var total_score:int = 0
	
	total_score += Global.save_data["total_gold"]
	total_score += Global.save_data["mom"] * 300.0
	total_score += Global.save_data["kid"] * 300.0
	total_score += Global.save_data["pet"] * 300.0
	total_score += max(0,300.0 - 50*max(0,(Global.save_data["completed_days"]-7)))
	total_score_value.text = "%5d"%[total_score]
	if total_score >= 1800:
		ranking.text = "S"
		ranking_description.text = "%s"%[tr("WIN_RANKING_DESCRIPTION_S")]
	elif total_score >= 1500:
		ranking.text = "A"
		ranking_description.text = "%s"%[tr("WIN_RANKING_DESCRIPTION_A")]
	elif total_score >= 1200:
		ranking.text = "B"
		ranking_description.text = "%s"%[tr("WIN_RANKING_DESCRIPTION_B")]
	elif total_score >= 900:
		ranking.text = "C"
		ranking_description.text = "%s"%[tr("WIN_RANKING_DESCRIPTION_C")]
	else:
		ranking.text = "D"
		ranking_description.text = "%s"%[tr("WIN_RANKING_DESCRIPTION_D")]
