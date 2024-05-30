extends "res://addons/gut/test.gd"

var PlayerScene = preload("res://Scenes/Player.tscn")
var player = null


func before_each():
	player = PlayerScene.instance()
	add_child(player)
	player._ready()  

func after_each():
	if player and player.get_parent():
		player.queue_free()

func test_take_damage():
	player.take_damage(50)
	assert_eq(player.actualLife, player.maxLife - 50, "La vida del jugador debería disminuir después de recibir daño")

func test_player_dies():
	# Simula la muerte del jugador
	player.take_damage(player.maxLife)
	player._physics_process(0.1)
	assert_eq(player.vidas, player.maxVidas - 1, "La cantidad de vidas del jugador debería disminuir")
