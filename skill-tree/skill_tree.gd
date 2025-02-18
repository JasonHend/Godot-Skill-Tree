extends Control

# Public variables to define how currency is managed and root of tree for saving purposes
@export var currency: int = 0
@onready var tree_root: Button = get_node("Panel/Skill Node")

# Path to save data
const SAVE_PATH := "user://skilltree.save"

# Load the saved tree on ready
func _ready() -> void:
	load_tree()

# Main overload for handling the purchase of nodes
func handle_node_purchase(skill_reference: String) -> void:
	match skill_reference:
		"FillIn":
			_test_skill_unlocked()
		_:
			print_debug("No function assigned with purchased node")
	
	# Save once a purchase has been made
	save_tree()

#region Skill Functions
# INFO Each function in this region is meant to be passed in to handle_node_purchase
# These functions serve as the logic for each node's activation
func _test_skill_unlocked() -> void:
	print_debug("A skill has just been unlocked")
#endregion

#region Save Logic
# INFO Functions for saving and loading each nodes state
func save_tree() -> void:
	# Reference to all nodes to be saved
	var tree_nodes = get_tree().get_nodes_in_group("TreeNodes")
	
	# File to save to
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	for node in tree_nodes:
		if node.scene_file_path.is_empty() or !node.has_method("save"):
			continue
		
		# Call save on each node
		var node_data = node.call("save")
		
		# Format into JSON
		var json_string = JSON.stringify(node_data)
		
		# Save and close file
		save_file.store_line(json_string)
		save_file.close()

func load_tree() -> void:
	# Check for file exsistance
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	# Loop through nodes and free the ones that will be loaded
	var tree_nodes = get_tree().get_nodes_in_group("TreeNodes")
	for node in tree_nodes:
		node.queue_free()
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		# JSON class and parsing
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			continue
		
		#grab data and load into a new object
		var node_data = json.data
		
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	save_file.close()
#endregion
