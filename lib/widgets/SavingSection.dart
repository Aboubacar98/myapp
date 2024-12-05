import 'package:flutter/material.dart';
import 'package:myapp/widgets/ActionButton.dart';

class SavingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final List<ActionButton> actions;

  const SavingsSection({
    required this.title,
    required this.icon,
    required this.description,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Color.fromARGB(255, 92, 174, 241),
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 92, 174, 241),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
