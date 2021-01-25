extends Area2D

var speed = 500
var vector: Vector2

onready var anim: AnimationPlayer = $spr/anim
onready var coll: CollisionShape2D = $coll

func _physics_process(delta) -> void:
	position += vector * speed * delta

func explode() -> void:
	speed = 0
	coll.call_deferred("set", "disabled", true)
	yield(get_tree().create_timer(1), "timeout")
	call_deferred("queue_free")

func _on_SelfDestroy_timeout() -> void:
	$spr/anim.play("Explode")

func _on_Bullet_body_entered(body) -> void:
	if body is TileMap:
		explode()
		$spr/anim.play("Explode")
	elif body is KinematicBody2D:
		print("enemy hit")
