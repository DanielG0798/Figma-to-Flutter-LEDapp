import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../models/light.dart';

class LightWidget extends StatelessWidget {
  final Light light;
  final VoidCallback onModify;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const LightWidget({
    super.key,
    required this.light,
    required this.onModify,
    required this.onToggle,
    required this.onDelete,
  });
  // Convert hex color string to Flutter Color
  Color _parseColor(String colorStr) {
    try {
      return Color(int.parse(colorStr.replaceFirst('#', '0xff')));
    } catch (_) {
      return const Color.fromARGB(255, 22, 5, 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Light name on the left
            Expanded(
              child: Text(
                light.lightName,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),

            FlutterSwitch(
              value: light.isOn,
              onToggle: onToggle,
              valueFontSize: 16,
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
              width: 55.0,
              height: 27.0,
              toggleSize: 16.0,
              borderRadius: 30.0,
              padding: 3.0,
              showOnOff: true,
            ),

            const SizedBox(width: 15), // spacing
            // Modify button with sample color circle
            Material(
              color: Colors.transparent,
              child: InkWell(
                // Inkwell adds ripple effect on tap
                onTap: onModify,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Tappable area
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _parseColor(light.lightColor),
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Modify'),
                    ],
                  ),
                ),
              ),
            ),
            // Add Delete Button (Trash Icon)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red), // Delete icon
              onPressed: onDelete, // Call the onDelete callback
              ),
            ],
          ),
        ),
      );
  }
}