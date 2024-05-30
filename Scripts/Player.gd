extends KinematicBody2D
class_name Player

const moveSpeed=100
const maxSpeed=200
const jumpHeight=-400
const gravity=10
const up=Vector2(0,-1)


onready var sprite=$Sprite
onready var animationPlayer=$AnimationPlayer

var enemyIsNear=false #Indica si algun enemigo que ese encuentra en rango de ataque
var enemy=null #Indica el cuerpo del enemigo que ese encuentra en rango de ataque
var isAlive=true #Indica si el jugador esta vivo
var isAttacking=false #Indica si el pj esta atacando
var motion=Vector2()


 
func _physics_process(delta):
	motion.y+= gravity
	var friction=false
	
	if Input.is_action_pressed("ui_right") and not isAttacking:
		sprite.flip_h=false
		motion.x=min(motion.x+moveSpeed,maxSpeed)
		
	elif Input.is_action_pressed("ui_left") and not isAttacking:
		sprite.flip_h=true
		motion.x=max(motion.x-moveSpeed,-maxSpeed)
		
	else:
		friction=true
		
	if is_on_floor():
		if Input.is_action_pressed("ui_up") and not isAttacking:
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
		
	attack()
	
	motion=move_and_slide(motion,up)
	

#Realiza el ataque y actualiza valores de vida del enemigo
func attack():
	#Punch quita 50 de vida
	if Input.is_action_pressed("ui_at1")  and not isAttacking:
		animationPlayer.play("Punch")

	#Kick quita 200 de vida
	if Input.is_action_pressed("ui_at2") and not isAttacking:
		animationPlayer.play("Kick")

#Actualiza la vida del Player y verifica si muere
func take_damage(damageTaken):
	Global.actualLife-=damageTaken
	if Global.actualLife<0:
		Global.actualLife=0
	if Global.actualLife==0:
		isAlive=false
	if not isAlive:
		set_global_position(Global.inicio)
		Global.actualLife=Global.maxLife
		Global.contador_vida-=1

#Signals of DeadArea
func _on_DeadArea_body_entered(body):
	set_global_position(Global.inicio)
	Global.contador_vida-=1
	
#Signals of AttackArea
func _on_AttackArea_body_entered(body):
	enemy=body
	enemyIsNear=true

func _on_AttackArea_body_exited(body):
	enemy=null
	enemyIsNear=false

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "Punch" or anim_name == "Kick":
		isAttacking=true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Punch":
		if enemyIsNear:
			enemy.take_damage(50)
		isAttacking=false
	if anim_name == "Kick":
		if enemyIsNear:
			enemy.take_damage(200)
		isAttacking=false

func save_game():
	return {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"x_pos" : position.x,
		"y_pos" : position.y,
		"stats" :{
			"contador_oro" : Global.contador_oro,
			"contador_plata" : Global.contador_plata,
			"contador_vida" : Global.contador_vida,
			"actualLife" : Global.actualLife,
			"contador_kills" : Global.contador_kills,
		}
	}

func load_game(stats):
	position = Vector2(stats.x_pos, stats.y_pos)
	Global.contador_oro = stats.stats.contador_oro
	Global.contador_plata = stats.stats.contador_plata
	Global.contador_vida = stats.stats.contador_vida
	Global.actualLife = stats.stats.actualLife
	Global.contador_kills = stats.stats.contador_kills
