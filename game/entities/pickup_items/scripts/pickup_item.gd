extends Area2D

# Child nodes
onready var _anim = $AnimationPlayer

# Items
enum Items {health, ammo}
export (Items) var type = Items.health
export (Vector2) var amount = Vector2(10, 25) # min/max

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _ready():
	_anim.play('bounce')

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_PickupItem_body_entered(body):
	match type:
		Items.health:
			if body.has_method('heal'):
				body.heal(int(rand_range(amount.x, amount.y)))
		Items.ammo:
			pass
	queue_free()
