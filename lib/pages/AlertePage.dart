import 'package:flutter/material.dart';

class AlertePage extends StatefulWidget {
  const AlertePage({super.key});

  @override
  State<AlertePage> createState() => _AlertepageState();
}

class _AlertepageState extends State<AlertePage> {

  bool hasNotifications = false;  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes notifications",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Couleur de fond blanche
        iconTheme: const IconThemeData(color: Colors.black), // Icônes en noir
      ),
      body: Center(
        child: hasNotifications
            ? const Text(
                "Vous avez des notifications",  // Affiché si des notifications sont présentes
                style: TextStyle(fontSize: 18),
              )
            : const Text(
                "Vous n'avez aucune notification",  // Affiché si aucune notification
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
      ),
    );
  }
}
