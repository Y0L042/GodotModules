extends Node

enum ParamsColors {
	STANDARD,
	ORANGE,
	RED,
}

enum ThemeColors {
	STANDARD,
	ORANGE,
	GREEN,
}

enum ThemeStyles {
	STANDARD,
	ORANGE,
	GREEN,
}

func print(i_sender: Variant, i_params: Array, i_params_color: String = 'white', i_theme_color: ThemeColors = ThemeColors.STANDARD, i_theme_style: ThemeStyles = ThemeStyles.STANDARD) -> void:
	var params_colors = {
		ParamsColors.STANDARD : 'white',
		ParamsColors.ORANGE : 'orange',
		ParamsColors.RED : 'red',
	}

	var theme_colors = {
		ThemeColors.STANDARD : ['white', 'gray', 'white'],
		ThemeColors.ORANGE : ['orange', 'orange', 'orange'],
		ThemeColors.GREEN : ['green', 'green', 'green'],
	}
	var theme_styles = {
		ThemeStyles.STANDARD : ['', ''],
		ThemeStyles.ORANGE : ['[b]', '[/b]'],
		ThemeStyles.GREEN : ['[b]', '[/b]']
	}

	var color_theme = i_theme_color
	var style_theme = i_theme_style

	var sender_name = '[i][color=%s]%s[/color][/i]' % [theme_colors[color_theme][0], i_sender.name]
	var location = get_stack()[1]
	var func_info = '[color=%s]%s @ %s()[/color]' % [theme_colors[color_theme][1], location.line, location.function]
	var pre_params = theme_styles[style_theme][0]
	var post_params = theme_styles[style_theme][1]

	var params_str = '[color=%s]' % i_params_color #params_colors[i_params_color]
	for param in i_params:
		params_str += ' ' + str(param)
	params_str += ' [/color]'

	var output = '%s [b] | [/b] %s [b]->[/b] %s%s%s' % [sender_name, func_info, pre_params, params_str, post_params]

	print_rich(output)
