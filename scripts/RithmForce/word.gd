extends CharacterBody2D

var id: int
var fall_speed: float
var word_text: String

var difficulty

func _ready() -> void:
	$RichTextLabel.text = word_text

func set_text(new_text: String) -> void:
	$RichTextLabel.text = new_text


func _physics_process(_delta: float) -> void:
	velocity.y = fall_speed
	move_and_slide()

func anim_error():
	$RichTextLabel.text = "[color=red]"+word_text+"[/color]"
	$AnimationPlayer.play("error")
	await $AnimationPlayer.animation_finished
	return
