extends CharacterBody2D

const SPEED: float = 600.0

signal hit
@onready var hurt_box: Area2D = $HurtBox

func _ready() -> void:
	add_to_group("player")
	hurt_box.area_entered.connect(_on_hurtbox_area_entered)

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	hit.emit()
