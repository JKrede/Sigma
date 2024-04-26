extends KinematicBody2D

const moveSpeed=10
const maxSpeed=100
const jumpHeight=-300

const up=Vector2(0,-1)
const gravity=10;

onready var sprite=$Sprite
onready var animationPlayer=$AnimationPlayer
var isAttacking=false #Variable que indica si el pj esta atacando


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
		##Aca iria el efecto de esto
		_on_AttackingFinished()
		
	if Input.is_action_pressed("ui_at2") and not isAttacking:
		animationPlayer.play("Kick")
		isAttacking=true
		##Aca iria el efecto de esto
		_on_AttackingFinished()
		
		
		
	motion=move_and_slide(motion,up)
	
	
func _on_AttackingFinished():
	yield(get_tree().create_timer(1), "timeout") #Funcion que pausa
	isAttacking=false #							la ejecucion de codigo durante 1 seg
