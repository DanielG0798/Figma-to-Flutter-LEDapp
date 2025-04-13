import 'package:flutter/material.dart';
import '../models/light.dart';

class LightWidget extends StatelessWidget {
  final Light light;
  final VoidCallback onModify;

  const LightWidget({
    super.key,
    required this.light,
    required this.onModify,
  });

  // Convert hex color string to Flutter Color
  Color _parseColor(String colorStr) {
    try {
      return Color(int.parse(colorStr.replaceFirst('#', '0xff')));
    } catch (_) {
      return Colors.white; // fallback if color string is invalid
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Light name on the left
            Expanded(
              child: Text(
                light.name,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),

            // Color circle
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _parseColor(light.color), //ToDo: color contrast discuss
                border: Border.all(color: Colors.black12),
              ),
            ),

            const SizedBox(width: 16),

            // Modify button with gear icon above
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.settings, size: 20),
                TextButton(
                  onPressed: onModify,
                  child: const Text('Modify'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
