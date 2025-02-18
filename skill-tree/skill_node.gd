extends Button

class_name TreeNode
# Public variables that determine acquisition requirements
@export var price: int = 0
@export var times_purchasable: int = 1
@export var purchasable: bool = false
@export var skill_refernce: String = "FillIn"

# Private variables for purchasing nodes
var _purchased: bool = false

# Reference to the tree base
@onready var _tree_base: Control = get_node("/root/TreeNode")

# Makes the children of the current node purchasable
func make_children_purchasable() -> void:
	var _children: Array = get_children()
	for _child in _children:
		if _child is TreeNode:
			_child.purchasable = true
			print_debug(_child.purchasable)

# Handles behavior when the node is pressed
func _on_pressed() -> void:
	var payment = 10
	if purchasable and !_purchased and price < payment:
		if times_purchasable > 1:
			times_purchasable -= 1
		else:
			purchasable = false
			_purchased = true
			_tree_base.handle_node_purchase(skill_refernce)
			make_children_purchasable()

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"price" : price,
		"times_purchasable" : times_purchasable,
		"purchasable" : purchasable,
		"skill_refernce" : skill_refernce,
		"purchased" : _purchased
	}
	return save_dict
