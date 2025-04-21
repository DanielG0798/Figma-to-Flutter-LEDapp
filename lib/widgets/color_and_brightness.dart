import 'package:flutter/material.dart';
import '../widgets/brightness_slider.dart'; 
import '../widgets/color_picker.dart'; 

Widget buildColorAndBrightnessPicker({
  required Color pickerColor,
  required double brightness,
  required ValueChanged<Color> onColorChanged,
  required ValueChanged<double> onBrightnessChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HueColorPicker(
        pickerColor: pickerColor,
        onColorChanged: onColorChanged,
      ),
      const SizedBox(height: 16),
      buildBrightnessSlider(
        brightness,
        pickerColor,
        onBrightnessChanged,
      ),
    ],
  );
}
