import 'package:flutter/material.dart';

class DebitPage extends StatefulWidget {
  const DebitPage({super.key});

  @override
  State<DebitPage> createState() => _DebitPageState();
}

class _DebitPageState extends State<DebitPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choisissez le compte à débiter",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Couleur de fond blanche
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,// Icônes en noir
      ),
    );
  }
}