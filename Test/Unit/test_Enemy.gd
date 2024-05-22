extends "res://addons/gut/test.gd"

var Enemy = load("res://Scripts/Enemy.gd")
var enemy=null
const maxLife=200

#Partes de codigo que se ejecutan antes de cada prueba
func before_each():
	enemy = Enemy.new()
#Partes de codigo que se ejecutan despues de cada prueba
func after_each():
	enemy.free()

func test_take_damage():
	enemy.take_damage(20)
	enemy.take_damage(50)
	assert_eq(enemy.actualLife, 130, "El resultado deberia ser 130")

func test_take_damage_not_below_zero():
	enemy.take_damage(300)
	assert_eq(enemy.actualLife, 0, "El resultado deberia ser 0")

func test_enemy_star_with_maxLife():
	assert_eq(enemy.actualLife, 200, "El resultado deberia ser maxLife=200")
