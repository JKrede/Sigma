extends Node

const maxLife=100.0
const maxVidas=5
const puntos_sushi = 30
const puntos_bebida = 20
const puntos_ramen = 50
const puntos_origi = 10
const inicio=Vector2(1,1)

var contador_vida = maxVidas
var actualLife = maxLife

var red = false
var blue = false
var green = false
var yellow = false
var contador_kills = 0
var contador_oro = 0
var contador_plata = 0

func reset_parameters():
	var actualLife = maxLife
	var contador_vida = maxVidas
	var contador_oro = 0
	var contador_plata = 0
	var contador_kills = 0
