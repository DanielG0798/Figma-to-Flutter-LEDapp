import 'package:flutter/material.dart';

Widget buildBrightnessSlider(double brightnessSelection, Color pickerColor,
    ValueChanged<double> onChanged) {
  final sliderColor = Color.lerp(
    const Color.fromARGB(142, 158, 158, 158),
    const Color.fromARGB(255, 255, 222, 57),
    (brightnessSelection - 1) / 99,
  )!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Brightness', style: TextStyle(fontSize: 16)),
          Text('${brightnessSelection.toInt()}%', style: TextStyle(fontSize: 16)),
        ],
      ),
      Slider(
        value: brightnessSelection,
        activeColor: sliderColor,
        inactiveColor: Colors.grey,
        onChanged: onChanged,
        min: 1,
        max: 100,
      ),
    ],
  );
}
