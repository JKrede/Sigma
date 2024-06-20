extends "res://addons/gut/test.gd"

var PlayerScene = preload("res://Scenes/Player.tscn")
var player = null

func before_each():
	player = PlayerScene.instance()
	add_child(player)
	player._ready()
	Global.reset_parameters()

func after_each():
	player.queue_free()
	player = null
	Global.reset_parameters()

func test_take_damage():
	player.take_damage(50)
	assert_eq(Global.actualLife, 50, "La vida del jugador debería reducirse correctamente")
	
func test_take_damage_below_to_zero():
	player.take_damage(200)
	assert_eq(Global.actualLife, 0, "La vida del jugador no debería ser menor a 0")
	
func test_live_check():
	player.take_damage(200)
	player.live_check()
	assert_eq(Global.contador_vida, 4, "El contador de vida debería decrementar")
	assert_eq(Global.actualLife, Global.maxLife, "La vida del jugador debería resetearse al máximo")
	assert_eq(player.position, player.inicio, "La posición del jugador debería resetearse")

func test_attack():
	player.isAttacking = false
	player.isTakingDamage = false
	player.motion.x = 0
	Input.action_press("ui_at1")
	player.attack()
	assert_true(player.isAttacking, "El jugador debería estar atacando después de presionar ui_at1")
	Input.action_release("ui_at1")
	Input.action_press("ui_at2")
	player.attack()
	assert_true(player.isAttacking, "El jugador debería estar atacando después de presionar ui_at2")
	Input.action_release("ui_at2")

