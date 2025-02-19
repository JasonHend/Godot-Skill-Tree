extends Control

# Public variables to define how currency is managed and root of tree for saving purposes
@export var currency: int = 10
@onready var tree_root: TreeNode = get_node("Panel/1")

# Path to save data
const SAVE_PATH := "user://skilltree.save"

# Private array for dynamic saving and loading of tree
var _all_nodes: Array

# Label for showing currency
@onready var _currency_label: Label = get_node("Panel/Label")

# Load the saved tree on ready
func _ready() -> void:
	_get_nodes(tree_root)
	_currency_label.text = "Currency: %d" % currency
	load_tree()

# Populate all nodes array
func _get_nodes(start_node: TreeNode) -> void:
	_all_nodes.append(start_node)
	
	# Get child nodes and call down to leafs
	var child_nodes = start_node.get_children()
	for child in child_nodes:
		if child is TreeNode:
			_get_nodes(child)

# Main overload for handling the purchase of nodes
func handle_node_purchase(skill_reference: String) -> void:
	_currency_label.text = "Currency: %d" % currency
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
#endregion

#region Save Logic
# INFO Functions for saving and loading each nodes state
# Override default quit behavoir to save needed nodes before termination
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_tree()
		get_tree().quit()

func save_tree() -> void:
	# File to save to
	var save_file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	for node in _all_nodes:
		if node.scene_file_path.is_empty() or !node.has_method("save"):
			continue
		
		# Call save
		var node_data = node.call("save")
		
		#Format and write
		var json_string = JSON.stringify(node_data)
		save_file.store_line(json_string)
	
	save_file.close()

func load_tree() -> void:
	# Check for file exsistance
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		# JSON class and parsing
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			continue
		
		# Grab data and load into a new object
		var node_data = json.data
		
		# Matching node based on filepath
		for node in _all_nodes:
			if node.name == node_data["name"]:
				node.load_data(node_data)
		
	save_file.close()
#endregion
