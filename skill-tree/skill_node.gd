extends Button

class_name TreeNode
# Public variables that determine acquisition requirements
@export var price: int = 1
@export var times_purchasable: int = 1
@export var purchasable: bool = false
@export var skill_reference: String = "FillIn"

# Variables for purchasing nodes
var purchased: bool = false
var times_purchased: int = 0

# Reference to the tree base
@onready var _tree_base: Control = get_node("/root/TreeNode")

# Reference to the display text
@onready var purchase_label: Label = get_node("Label")

func _ready() -> void:
	purchase_label.text = str(times_purchased) + "/" + str(times_purchasable)

# Makes the children of the current node purchasable
func make_children_purchasable() -> void:
	var _children: Array = get_children()
	for _child in _children:
		if _child is TreeNode:
			_child.purchasable = true

# Handles behavior when the node is pressed
func _on_pressed() -> void:
	var payment = _tree_base.currency
	if purchasable and !purchased and price <= payment:
		_tree_base.currency -= price
		times_purchased += 1
		if times_purchased < times_purchasable:
			_tree_base.handle_node_purchase(skill_reference)
			purchase_label.text = str(times_purchased) + "/" + str(times_purchasable)
		else:
			purchasable = false
			purchased = true
			_tree_base.handle_node_purchase(skill_reference)
			purchase_label.text = str(times_purchased) + "/" + str(times_purchasable)
			make_children_purchasable()

func save() -> Dictionary:
	var save_dict = {
		"name" : self.name,
		"times_purchased" : times_purchased,
		"purchasable" : purchasable,
		"purchased" : purchased
	}
	return save_dict

func load_data(node_data) -> void:
	self.times_purchased = node_data["times_purchased"]
	self.purchasable = node_data["purchasable"]
	self.purchased = node_data["purchased"]
	purchase_label.text = str(times_purchased) + "/" + str(times_purchasable)
