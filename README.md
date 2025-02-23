# Skill Tree Simple
A simple skill tree package for Godot projects
- Includes customizable nodes
- Saves node data in .SAVE file
- Allows inspector changes to specific nodes
- Split up into design and development workflows

# Design Workflow
Each node can be designed within the inspector in both functionality and presentation, with no coding necessary.
- [Instantiating new nodes](#instantiating-new-nodes)
- [Changing node values](#changing-node-values)
- [Presentation of node](#node-presentation)

## Instantiating New Nodes
To place a new node onto the skill tree, use the instantiate scene button in the scene view.  
![Screenshot of scene view and instantiate button](/DocumentationAssets/instantiate.png)  
Next, place the node onto the skill hierarchy as a child of the skill node that will be its parent.

## Changing Node Values
Each node's functionality can be changed easily within the inspector by altering the export variables placed on each node. This can be found on the right of the inspector under the node tab.  
![Screenshot of node tab and variables to edit](/DocumentationAssets/node.png)  
This section includes references to the node's price, the number of times a player can purchase the node, the ability to purchase the node at the start, and the skill that the node references.
All of these nodes will automatically update with the information that is filled in using the inspector at compile time.

## Node Presentation
Presentation for all nodes can be changed within the skill_node.tscn file or can be changed instance by instance within the skill tree itself. Since each node inherits from the button node in Godot,
all properties that are customizable are available [Here](https://docs.godotengine.org/en/stable/classes/class_button.html#theme-properties). This includes changing the icon of the button and its visual behavior when pressed.

# Development Workflow
The development for each node is condensed down into editing two functions, as hooking up the nodes will be done through references in the inspector which is covered in the Design workflow.
- [Node Functionality](#node-functionality)
- [Skill Match](#skill-match)

## Node Functionality
Since each node is a simple container of information, the skill_tree.gd script is where the bulk of the functionality is. For each skill wanted in the game, add your custom functions to the skill function region.
How data will be handled is up to the interpretation of the developer, so feel free to experiment and get the functionality for new skills.  
![Screenshot of the skill function region](/DocumentationAssets/function.png)

## Skill Match
Each node has an export string named skill_reference, this is how the skill_tree.gd script will decide what function to call. To add a new skill_reference, simply write a new case using the [match format](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#match) of Godot.
It is a good idea to keep in the underscore case as it is the default in match, ensuring no crashes if a skill does not have a matching skill_reference.  
![Screenshot of the skill match](/DocumentationAssets/match.png)

## Note About Saving
This system utilizes basic file input-output systems in Godot, and it matches each skill based on its name in the inspector. The main reason I chose to save based on the inspector name is ambiguity in save files, it can create issues if two skill nodes have the same name,
but it also hides which node belongs to which skill and allows for two nodes to have the same skill reference. This, as well as the default file path, can be changed based on use case, there is a file path extension in the skill_tree.gd script.
Additionally, the way the skills are saved is found in the save function of the same script, just ensure that it matches in load if anything has been changed.
