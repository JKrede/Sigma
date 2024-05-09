extends KinematicBody2D

const moveSpeed=100
const maxSpeed=200
const jumpHeight=-400
const maxLife=100
const maxVidas=5
const gravity=10
const up=Vector2(0,-1)
const inicio=Vector2(1,1)

onready var sprite=$Sprite
onready var animationPlayer=$AnimationPlayer

var enemyIsNear =false
var enemy=null
var isAttacking=false #Variable que indica si el pj esta atacando
var actualLife=maxLife #Vida actual del pj
var actualVidas=maxVidas-2
var motion=Vector2()
 
func _physics_process(delta):
	motion.y+= gravity
	var friction=false
	
	if Input.is_action_pressed("ui_right"):
		sprite.flip_h=false
		motion.x=min(motion.x+moveSpeed,maxSpeed)
		
	elif Input.is_action_pressed("ui_left"):
		sprite.flip_h=true
		motion.x=max(motion.x-moveSpeed,-maxSpeed)
		
	else:
		friction=true
		
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y=jumpHeight
			animationPlayer.play("Jump")
		if friction==true:
			motion.x=lerp(motion.x,0,1)
		if motion.x!=0:
			animationPlayer.play("Walk")
		
		if motion.x==0 and not isAttacking:
			animationPlayer.play("Idle")
		
	else:
		if friction==true:
			motion.x=lerp(motion.x,0,1)
		if motion.y<0 and not isAttacking:
			animationPlayer.play("Fall")
		
	if Input.is_action_pressed("ui_at1")  and not isAttacking:
		animationPlayer.play("Punch")
		isAttacking=true
		if enemyIsNear:
			enemy.actualLife-=50
		_on_attack_finished()
		
	if Input.is_action_pressed("ui_at2") and not isAttacking:
		animationPlayer.play("Kick")
		isAttacking=true
		if enemyIsNear:
			enemy.actualLife-=200
		_on_attack_finished()
		
		
	motion=move_and_slide(motion,up)

#Signals of DeadArea
func _on_DeadArea_body_entered(body):
	set_global_position(inicio)
	actualVidas-=1
	print(actualVidas)
	
#Signals of AttackArea
func _on_AttackArea_body_entered(body):
	enemy=body
	enemyIsNear=true

func _on_AttackArea_body_exited(body):
	enemy=null
	enemyIsNear=false

func _on_attack_finished():
	yield(get_tree().create_timer(0.7), "timeout")
	isAttacking=false
