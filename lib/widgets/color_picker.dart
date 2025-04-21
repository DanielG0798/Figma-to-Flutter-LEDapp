import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HueColorPicker extends StatelessWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const HueColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      pickerColor: pickerColor,
      onColorChanged: onColorChanged,
      paletteType: PaletteType.hueWheel,
      enableAlpha: false,
      displayThumbColor: true,
      pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(12)),
    );
  }
}
