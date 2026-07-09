extends Node2D

const LIVES: int = 3

var lives: int = LIVES
var time_alive: float = 0.0
var is_dead: bool = false

@onready var emitter: Node2D = $Emitter
@onready var bullet_pool: Node2D = $BulletPool
@onready var player: CharacterBody2D = $Player
@onready var timer_label: Label = $Hud/TimerLabel
@onready var death_screen: Control = $Hud/DeathScreen
@onready var health_label: Label = $Hud/HealthLabel

func _ready() -> void:
	emitter.position = Vector2(640, 360)
	player.position = Vector2(640, 560)
	player.hit.connect(_on_player_hit)
	death_screen.visible = false
	death_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	health_label.text = str(lives)
	$Hud/DeathScreen/BackGround/VBoxContainer/RestartButton.pressed.connect(_on_restart)

func _process(delta: float) -> void:
	if is_dead:
		return
	
	time_alive += delta
	timer_label.text = "TIME: " + "%.1f" % time_alive
	_move_bullets(delta)

func _move_bullets(delta: float) -> void:
	var screen := get_viewport_rect()
	for bullet in bullet_pool.get_children():
		if not bullet.visible:
			continue
	
		var vel: Vector2 = bullet.get_meta("velocity", Vector2.ZERO)
		bullet.global_position += vel * delta
		var pos: Vector2 = bullet.global_position
		if pos.x < -50 or pos.x > screen.size.x + 50 or \
		pos.y < -50 or pos.y > screen.size.y + 50:
			bullet_pool.return_bullet(bullet)
			
func _on_player_hit() -> void:
	lives -= 1
	health_label.text = str(lives)
	if lives <= 0:
		_die()

func _die() -> void:
	is_dead = true
	death_screen.visible = true
	$Hud/DeathScreen/BackGround/VBoxContainer/TimeLabel.text = "TIME: " + "%.1f" % time_alive
	
func _on_restart() -> void:
	get_tree().reload_current_scene()
