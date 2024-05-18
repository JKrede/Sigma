extends KinematicBody2D

const up = Vector2(0, -1)
const gravity = 10
const moveSpeed = 60
const maxLife=200

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

var player_chase = false
var player_attack =false
var player = null
var actualLife=maxLife
var isAlive=true
var motion = Vector2()

func _physics_process(delta):
	motion.y+= gravity
	var friction=false
	motion.x=0
	
	if player_chase and not player_attack and isAlive:
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
			
	elif not player_chase and not player_attack and isAlive:
		if motion.x==0:
			animationPlayer.play("Idle")
	
	if player_attack and isAlive:
		animationPlayer.play("Attack")
		yield(get_tree().create_timer(0.8), "timeout")
		if player_attack:
			player.actualLife
	
	if actualLife<=0:
		isAlive=false
	
	if not isAlive:
		yield(get_tree().create_timer(0.4), "timeout")
		animationPlayer.play("Dead")
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()
		
	move_and_slide(motion, up)
	
#Signals of DetectionArea
func _on_DetectionArea_body_entered(body):
	player = body
	player_chase = true
func _on_DetectionArea_body_exited(body):
	player_chase = false

#Signals of AttackArea
func _on_AttackArea_body_entered(body):
	player_attack=true
func _on_AttackArea_body_exited(body):
	player_attack=false
