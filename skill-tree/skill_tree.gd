extends Control

# Public variables to define how currency is managed and root of tree for saving purposes
@export var currency: int = 0
@onready var tree_root: Button = get_node("Panel/Skill Node")

# Main overload for handling the purchase of nodes
func handle_node_purchase(skill_reference: String) -> void:
	match skill_reference:
		"FillIn":
			_test_skill_unlocked()
		_:
			print_debug("No function assigned with purchased node")

#region Skill Functions
# INFO Each function in this region is meant to be passed in to handle_node_purchase
# These functions serve as the logic for each node's activation
func _test_skill_unlocked() -> void:
	print_debug("A skill has just been unlocked")
#endregion Skill Functions
