tool
extends StaticBody2D

# Obstacles
enum Items {barrelBlack_side, barrelBlack_top, barrelGreen_side, 
			barrelGreen_top, barrelRed_side, barrelRed_top,
			barrelRust_side, barrelRust_top, barricadeMetal,
			barricadeWood, fenceRed, fenceYellow, sandbagBeige,
			sandbagBeige_open, sandbagBrown, sandbagBrown_open,
			treeBrown_large, treeBrown_small, treeGreen_large,
			treeGreen_small
			}

export (String, FILE) var spritesheet
export (Items) var obstacle_type setget set_obstacle_type

var _regions = { # referenced from xml file
	Items.barrelBlack_side: Rect2(652, 532, 40, 56),
	Items.barrelBlack_top: Rect2(645, 220, 48, 48),
	Items.barrelGreen_side: Rect2(652, 476, 40, 56),
	Items.barrelGreen_top: Rect2(597, 220, 48, 48),
	Items.barrelRed_side: Rect2(648, 420, 40, 56),
	Items.barrelRed_top: Rect2(645, 172, 48, 48),
	Items.barrelRust_side: Rect2(652, 588, 40, 56),
	Items.barrelRust_top: Rect2(597, 172, 48, 48),
	Items.barricadeMetal: Rect2(596, 532, 56, 56),
	Items.barricadeWood: Rect2(596, 72, 56, 56),
	Items.fenceRed: Rect2(243, 336, 96, 32),
	Items.fenceYellow: Rect2(128, 216, 104, 32),
	Items.sandbagBeige: Rect2(436, 164, 64, 44),
	Items.sandbagBeige_open: Rect2(348, 518, 84, 55),
	Items.sandbagBrown: Rect2(440, 622, 64, 44),
	Items.sandbagBrown_open: Rect2(248, 596, 84, 55),
	Items.treeBrown_large: Rect2(0, 0, 128, 128),
	Items.treeBrown_small: Rect2(592, 694, 72, 72),
	Items.treeGreen_large: Rect2(0, 128, 128, 128),
	Items.treeGreen_small: Rect2(520, 694, 72, 72),
	}

################################################################################
# SETTERS
################################################################################

func set_obstacle_type(value):
	obstacle_type = value
	
	if !Engine.editor_hint:
        yield(self, 'tree_entered')
	
	# Set sprite
	assert spritesheet
	var sprite = $Sprite
	var atlas = AtlasTexture.new()
	sprite.texture = atlas
	# Need to reload spritesheet or new instances of this node will overwrite
	# the texture of other instances in the scene.
	sprite.texture.atlas = load(spritesheet)
	sprite.texture.region = _regions[obstacle_type]
	
	# Set collision
	var collision = $CollisionShape2D
	var rect = RectangleShape2D.new()
	rect.extents = sprite.texture.region.size / 2
	collision.shape = rect
