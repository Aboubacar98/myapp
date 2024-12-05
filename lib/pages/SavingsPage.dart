import 'package:flutter/material.dart';
import 'package:myapp/widgets/ActionButton.dart';
import 'package:myapp/widgets/SavingSection.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Epargne"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 92, 174, 241),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bienvenue sur votre espace d'épargne!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 92, 174, 241),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Profitez d’une expérience unique d’épargne qui vous aidera à prendre votre envol vers une meilleure gestion financière.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            // Liste des sections d’épargne dans un ListView séparé
            ListView(
              shrinkWrap:
                  true, // Pour permettre au ListView de prendre seulement l'espace nécessaire
              physics:
                  const NeverScrollableScrollPhysics(), // Désactive le défilement interne
              children: const [
                SavingsSection(
                  title: "Caisse",
                  icon: Icons.savings,
                  description:
                      "Un espace sécurisé pour garder et faire croître vos économies personnelles à votre rythme.",
                  actions: [
                    ActionButton(
                      label: "Créer une caisse",
                    ),
                    //ActionButton(label: "Retirer"),
                  ],
                ),
                SizedBox(height: 16),
                SavingsSection(
                  title: "Tontine",
                  icon: Icons.groups,
                  description:
                      "Épargnez ensemble pour atteindre vos objectifs communs et bénéficiez d’un soutien collectif.",
                  actions: [
                    ActionButton(label: "Rejoindre une Tontine"),
                    ActionButton(label: "Créer une Tontine"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
