extends "res://addons/gut/test.gd"

var EnemyScene = preload("res://Scenes/Enemy.tscn")
var enemy = null
const maxLife = 200

func before_each():
	enemy = EnemyScene.instance()
	add_child(enemy) 
	enemy._ready()
	
func after_each():
	enemy.queue_free()

func test_take_damage():
	enemy.take_damage(20)
	enemy.take_damage(50)
	assert_eq(enemy.actualLife, maxLife-70, "El resultado debería ser 130")

func test_take_damage_not_below_zero():
	enemy.take_damage(300)
	assert_eq(enemy.actualLife, 0, "El resultado debería ser 0")

func test_enemy_starts_with_maxLife():
	assert_eq(enemy.actualLife, 200, "El resultado debería ser maxLife=200")

func test_live_check():
	enemy.take_damage(20)
	enemy.take_damage(200)
	advance_time(0.5)
	assert_true(enemy.isAlive == false, "Luego de recibir 200 o más de daño debería morir")

func test_live_check2():
	enemy.take_damage(70)
	advance_time(0.5)  
	assert_false(enemy.isAlive == false, "Luego de recibir menos de 200 de daño debería seguir vivo")

func test_enemy_moves_towards_player():
	var player = Node2D.new()
	var initial_position = Vector2(0, 0)
	player.position = initial_position
	enemy.position = Vector2(10, 0)
	add_child(player)
	enemy._on_DetectionArea_body_entered(player)
	enemy.player = player
	advance_time(5)  
	assert_true(enemy.position.x != initial_position.x, "El enemigo debería moverse hacia el jugador")

func test_enemy_alive_status():
	assert_true(enemy.isAlive, "El enemigo debería estar vivo inicialmente")
	enemy.take_damage(maxLife)
	advance_time(0.5) 
	assert_false(enemy.isAlive, "El enemigo debería estar muerto después de recibir daño crítico")

func test_animation_changes_on_damage():
	enemy.take_damage(10)
	advance_time(0.1)  
	assert_true(enemy.animationPlayer.current_animation == "TakingDamage", "El enemigo debería estar reproduciendo la animación de daño")

func test_enemy_stops_chasing_player():
	var player = Node2D.new()
	add_child(player)
	enemy._on_DetectionArea_body_entered(player)
	enemy.player = player
	advance_time(1)  
	enemy._on_DetectionArea_body_exited(player)
	advance_time(0.1) 
	assert_false(enemy.playerChase, "El enemigo debería dejar de seguir al jugador cuando sale del área de detección")
	
# Función para avanzar el tiempo en las pruebas
func advance_time(seconds):
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = seconds
	timer.one_shot = true
	timer.start()
	yield(timer, "timeout")
	timer.queue_free()
