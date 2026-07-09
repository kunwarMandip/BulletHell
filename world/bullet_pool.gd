extends Node2D

const BULLET_SCENE = preload("uid://co0iodrv2aaeb")
const POOL_SIZE: int = 150

func _ready() -> void:
	for i in POOL_SIZE:
		var bullet = BULLET_SCENE.instantiate()
		add_child(bullet)
		bullet.visible = false
		bullet.process_mode = Node.PROCESS_MODE_DISABLED

func get_bullet() -> Node2D:
	for bullet in get_children():
		if not bullet.visible:
			return bullet
	return null

func return_bullet(bullet: Node2D) -> void:
	bullet.visible = false
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
	bullet.set_meta("velocity", Vector2.ZERO)
