import 'package:flutter/material.dart';

class CardRequired extends StatelessWidget {
  const CardRequired({super.key, required this.icon, required this.title, required this.subtitle,});
  final Image icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: icon,
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
