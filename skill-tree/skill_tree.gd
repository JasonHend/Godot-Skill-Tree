extends Control

# Public variables to define how currency is managed and root of tree for saving purposes
@export var currency: int = 0
@onready var tree_root: Button = get_node("Panel/Skill Node")

# Main overload for handling the purchase of nodes
func handle_node_purchase(node_attributes: String) -> void:
	match node_attributes:
		"FillIn":
			print_debug("This node was purchased")
		"Test":
			print_debug("Another node was puchased")
