import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/home_page.dart';

class ShowPinDialog extends StatefulWidget {
  final String phoneNumber;
  final String amount;
  final String transactionType; // "Crédit" ou "Débit"

  const ShowPinDialog({
    super.key,
    required this.phoneNumber,
    required this.amount,
    required this.transactionType, // Type de la transaction
  });

  @override
  _ShowPinDialogState createState() => _ShowPinDialogState();
}

class _ShowPinDialogState extends State<ShowPinDialog> {
  final TextEditingController _pinController = TextEditingController();
  final String _defaultPin = "1234"; // Code PIN par défaut

  // Méthode pour sauvegarder une transaction dans Firestore
  Future<void> _saveTransaction(double amount, String type, String phoneNumber) async {
    final transaction = {
      "amount": amount,
      "type": type,  // "Débit" ou "Crédit" selon le type de transaction
      "phoneNumber": phoneNumber,
      "date": DateTime.now(),
    };

    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(phoneNumber);
      final mainTransactionCollection = FirebaseFirestore.instance.collection('transactions'); // Collection principale des transactions

      // Récupérer le solde actuel
      final snapshot = await userDoc.get();

      if (!snapshot.exists) {
        // Si l'utilisateur n'existe pas, créer un nouveau document avec un solde initial
        await userDoc.set({
          "balance": amount,
        });
      } else {
        final currentBalance = snapshot.data()?['balance'] ?? 0.0;
        final newBalance = currentBalance + (type == "Débit" ? -amount : amount); // Calcul du solde en fonction du type de transaction

        // Mettre à jour le solde
        await userDoc.update({"balance": newBalance});
      }

      // Ajouter la transaction uniquement à la collection principale "transactions"
      await mainTransactionCollection.add(transaction);

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction effectuée avec succès !')),
      );

      // Attendre 2 secondes avant de rediriger
      await Future.delayed(const Duration(seconds: 2));

      Navigator.pop(context); // Fermer la boîte de dialogue
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
      );
    }
  }

  // Méthode pour valider le PIN
  Future<void> _validateTransfer() async {
    // Vérifier si le PIN est correct
    if (_pinController.text == _defaultPin) {
      // Récupérer le montant et le type de transaction
      double amount = double.parse(widget.amount);
      String transactionType = widget.transactionType;

      // Sauvegarder la transaction
      await _saveTransaction(amount, transactionType, widget.phoneNumber);

      // Fermer le dialogue après la transaction
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      //Navigator.of(context).popUntil((route) => route.isFirst, newRoute)
    } else {
      // Afficher un message d'erreur si le PIN est incorrect
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Code PIN incorrect")),
      );
    }
  }

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Conteneur pour "Entrez votre Pin" avec un fond bleu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Entrez votre Pin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Afficher les informations du transfert
            Text(
              "${widget.transactionType == 'Débit' ? 'Débit' : 'Crédit'} de ${widget.amount} GNF à ${widget.phoneNumber}",
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            // Champ pour entrer le code PIN
            TextField(
              controller: _pinController,
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
                  onPressed: _validateTransfer,
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
