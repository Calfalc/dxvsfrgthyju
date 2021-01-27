extends Node2D

var is_initialized := false

var _enemy: BaseEnemy = null
var _player: Player = null
var _nav_2d: Navigation2D = null
var _nearby_enemies: Array

onready var player_detection_area: Area2D = $PlayerDetectionArea
onready var enemy_detection_area: Area2D = $EnemyDetectionArea

onready var state = {
	DISABLED = $StateDisabled,
	ATTACK = $StateAttack,
}
onready var current_state: AIState = state.DISABLED setget set_state


func set_state(new_state: AIState):
	if new_state == current_state:
		return
	current_state = new_state


func initialize(enemy: BaseEnemy, player: Player, nav_2d: Navigation2D) -> void:
	is_initialized = true
	_enemy = enemy
	_player = player
	_nav_2d = nav_2d


func execute(delta: float) -> void:
	if current_state:
		current_state.execute(delta, _enemy, self, _player, _nav_2d, _nearby_enemies)
	else:
		push_error("Tried to execute current state but found null")


func _on_PlayerDetectionArea_body_entered(body: Node) -> void:
	if body.is_in_group("player") and is_initialized:
		self.current_state = state.ATTACK


func _on_EnemyDetectionArea_body_entered(body):
	if body == _enemy:
		return
	_nearby_enemies.append(body)


func _on_EnemyDetectionArea_body_exited(body):
	if body == _enemy:
		return
	_nearby_enemies.erase(body)
