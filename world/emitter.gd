extends Node2D

const BULLET_SPEED: float = 200.0

var pool: Node2D = null
var player: Node2D = null
var time: float = 0.0
var pattern: int = 0
var spiral_angle: float = 0.0
var fire_timer: float = 0.0
var pattern_timer: float = 0.0

@onready var pattern_label: Label = $"../Hud/PatternLabel"

const FIRE_RATES: Array[float] = [0.08, 0.05, 0.12]
const PATTERN_DURATION: float = 10.0

func _ready() -> void:
	pool = get_parent().get_node("BulletPool")
	player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	time += delta
	fire_timer -= delta
	pattern_timer -= delta
	
	if pattern_timer <= 0.0:
		pattern = (pattern + 1) % 3
		pattern_timer= PATTERN_DURATION
		pattern_label.text = _pattern_name()
	
	if fire_timer <= 0.0:
		_fire_pattern()
		fire_timer = _get_fire_rate()

func _get_fire_rate() -> float:
	var base: float = FIRE_RATES[pattern]
	var scale: float = max(0.4, 1.0 - time * 0.05)
	return base * scale

func _fire_pattern() -> void:
	match pattern:
		0: _pattern_spread()
		1: _pattern_spiral()
		2: _pattern_aimed()
	
func _pattern_spread() -> void:
	var count: int = 0
	for i in count:
		var angle := (TAU/ count) * i
		_spawn_bullet(Vector2.RIGHT.rotated(angle))

func _pattern_spiral() -> void:
	spiral_angle += 0.25
	_spawn_bullet(Vector2.RIGHT.rotated(spiral_angle))
	_spawn_bullet(Vector2.RIGHT.rotated(spiral_angle + PI))

func _pattern_aimed() -> void:
	if player == null:
		return
	
	var dir := (player.global_position - global_position).normalized()
	var spread: int = 3
	for i in spread:
		var offset := (i - spread / 2) * 0.2
		_spawn_bullet(dir.rotated(offset))

func _spawn_bullet(direction: Vector2) -> void:
	var bullet = pool.get_bullet()
	if bullet == null:
		return
		
	bullet.global_position = global_position
	bullet.visible = true
	bullet.process_mode = Node.PROCESS_MODE_INHERIT
	bullet.set_meta("velocity", direction * _get_bullet_spread())

func _get_bullet_spread() -> float:
	return BULLET_SPEED + time * 2.0
	
func _pattern_name() -> String:
	match pattern:
		0: return "SPREAD"
		1: return "SPIRAL"
		2: return "AIMED"
	return ""
	
