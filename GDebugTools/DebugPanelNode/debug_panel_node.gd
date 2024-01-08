class_name DebugPanelNode
extends Control

@export var panel_item_parent: VBoxContainer
@export var visible_by_default: bool = false

static var self_scene: PackedScene = preload("res://GodotModules/GDebugTools/DebugPanelNode/debug_panel_node.tscn")

func _ready() -> void:
	GDebug.panel = self
	visible = visible_by_default

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("debug_toggle_panel"): visible = !visible

func add_property(i_label_title: String, i_label_value: Variant, i_order_value: int = -1) -> void:
	var target: Label
	target = panel_item_parent.find_child(i_label_title, true, false)
	if !target:
		target = Label.new()
		# target.clip_text = true
		panel_item_parent.add_child(target)
		target.name = i_label_title
		target.text = i_label_title + " : " + str(format_value_by_type(i_label_value))
	elif visible:
		target.text = i_label_title + " : " + str(format_value_by_type(i_label_value))
		if i_order_value >= 0:
			panel_item_parent.move_child(target, i_order_value)

func remove_property(i_label_title: String) -> void:
	var target: Label = panel_item_parent.find_child(i_label_title, true, false)
	if target:
		target.queue_free()

func format_value_by_type(i_value: Variant) -> Variant:
	match typeof(i_value):
		TYPE_FLOAT:
			return "%.2f" % i_value
		TYPE_VECTOR3:
			return "(%.2f, %.2f, %.2f)" % [i_value.x, i_value.y, i_value.z]

	return i_value

static func spawn(i_parent: Node) -> Node:
	var node_self: Node = self_scene.instantiate()
	i_parent.add_child(node_self)
	return node_self
