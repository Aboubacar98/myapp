import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowPinDialog extends StatelessWidget {
  final String phoneNumber;
  final String amount;

  const ShowPinDialog({
    super.key,
    required this.phoneNumber,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch, // Étendre horizontalement
          children: [
            // Conteneur pour "Entrez votre Pin" avec un fond bleu
            Container(
              width: double.infinity, // Prend toute la largeur disponible
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.blue, // Fond bleu
                borderRadius: BorderRadius.circular(8), // Coins arrondis
              ),
              child: const Center(
                child: Text(
                  "Entrez votre Pin",
                  style: TextStyle(
                    color: Colors.white, // Texte en blanc
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Afficher les informations du transfert
            Text(
              "Transfert de $amount GNF à $phoneNumber",
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            // Champ pour entrer le code PIN
            TextField(
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.black),
                hintText: "Code PIN",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Boutons Annuler et Valider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Annuler",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Action pour valider le transfert
                  },
                  child: const Text(
                    "Valider",
                    style: TextStyle(color: Colors.blue),
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