extends KinematicBody2D

const up = Vector2(0, -1)
const gravity = 10
const moveSpeed = 60
const maxLife=200


onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

var playerChase = false
var playerAttack =false
var player = null
var actualLife=maxLife
var isAlive=true
var isTakingDamage=false
var damage=10

var motion = Vector2()

func _physics_process(delta):
	motion.y+= gravity
	var friction=false
	motion.x=0
	
	motion()
	attack()
	
	move_and_slide(motion, up)
	
#se encarga del movimiento del enemigo: si el player esta dentro de la zona de deteccion lo sigue
func motion():
	if playerChase and not playerAttack and isAlive and not isTakingDamage:
		# Calcula la dirección unitaria hacia la posición X del jugador [el +1 para evitar division por 0]
		motion.x=((player.position.x-position.x)/(abs(player.position.x-position.x)+1))* moveSpeed
		
		if (player.position.x-position.x)==0:
			animationPlayer.play("Idle")
			
		if motion.x > 0:
			sprite.flip_h = false
			animationPlayer.play("Walk")
			
		elif motion.x < 0:
			sprite.flip_h = true
			animationPlayer.play("Walk")
			
	elif not playerChase and not playerAttack and isAlive and not isTakingDamage:
		if motion.x==0:
			animationPlayer.play("Idle")

#Actualiza la vida del enemigo
func take_damage(damageTaken):
	animationPlayer.play("TakingDamage")
	actualLife-=damageTaken
	if actualLife<0:
		actualLife=0
	live_check()

#verifica si el player esta en area de ataque y ataca
func attack():
	if playerAttack and isAlive and not isTakingDamage:
		animationPlayer.play("Attack")

#Verifica si muere
func live_check():
	if actualLife==0:
		isAlive=false
	if not isAlive:
		animationPlayer.play("Dead")
		delete_enemy()

#Borra el enemigo
func delete_enemy():
	yield(get_tree().create_timer(0.4), "timeout")
	Global.contador_kills+=1
	queue_free()

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "TakingDamage":
		isTakingDamage=true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		# Aquí puedes ejecutar las acciones que quieres realizar después de que la animación de ataque ha terminado
		player.take_damage(damage)
	if anim_name == "TakingDamage":
		isTakingDamage=false

#Signals of DetectionArea
func _on_DetectionArea_body_entered(body):
	player = body
	playerChase = true
func _on_DetectionArea_body_exited(body):
	playerChase = false

#Signals of AttackArea
func _on_AttackArea_body_entered(body):
	playerAttack=true
func _on_AttackArea_body_exited(body):
	playerAttack=false

func save_game():
	return {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"x_pos" : position.x,
		"y_pos" : position.y,
		"stats" :{
			"actualLife" : actualLife,
			"isAlive" : isAlive
		}
	}

func load_game(stats):
	position = Vector2(stats.x_pos, stats.y_pos)
	actualLife = stats.stats.actualLife
	isAlive = stats.stats.isAlive
