import 'package:flutter/material.dart';

class CardRequired extends StatelessWidget {
  const CardRequired({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    required this.onTrailingPressed,
  });

  final Image icon;
  final String title;
  final String subtitle;
  final IconData trailingIcon;
  final VoidCallback onTrailingPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: icon,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: GestureDetector(
          onTap: onTrailingPressed,
          child: CircleAvatar(
            backgroundColor: Colors.purple,
            child: Icon(
              trailingIcon,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
