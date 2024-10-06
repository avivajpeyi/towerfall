extends RigidBody2D
class_name BallProjectile

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Handle collision (e.g., damage enemy, destroy projectile)
	queue_free()
