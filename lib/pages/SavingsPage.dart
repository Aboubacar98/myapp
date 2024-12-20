import 'package:flutter/material.dart';
import 'package:myapp/pages/BoxPage.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Epargne"),
        centerTitle: true,
        backgroundColor: Colors.blue,
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
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Profitez d’une expérience unique d’épargne qui vous aidera à prendre votre envol vers une meilleure gestion financière.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            // Liste des sections d’épargne sans ListView, juste une colonne
            SavingsSection(
              title: "Caisse",
              icon: Icons.savings,
              description:
                  "Un espace sécurisé pour garder et faire croître vos économies personnelles à votre rythme.",
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BoxPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Créer une caisse",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Si vous souhaitez ajouter un autre bouton, décommentez la ligne suivante
                // ElevatedButton(label: "Retirer"),
              ],
            ),
            const SizedBox(height: 16),
            SavingsSection(
              title: "Tontine",
              icon: Icons.groups,
              description:
                  "Épargnez ensemble pour atteindre vos objectifs communs et bénéficiez d’un soutien collectif.",
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // Action pour rejoindre une tontine
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Rejoindre une Tontine",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Action pour créer une tontine
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Créer une Tontine",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget SavingsSection pour afficher les actions
class SavingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final List<Widget> actions;

  const SavingsSection({
    required this.title,
    required this.icon,
    required this.description,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      color: Colors.white, // Fond blanc pour la section
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            // Affichage des actions sous forme de boutons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
