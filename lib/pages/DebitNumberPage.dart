import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/AccountPage.dart';
import 'package:myapp/pages/home_page.dart';

class DebitNumberPage extends StatefulWidget {
  final String phoneNumber;

  const DebitNumberPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _DebitNumberPageState createState() => _DebitNumberPageState();
}

class _DebitNumberPageState extends State<DebitNumberPage> {
  final TextEditingController amountController = TextEditingController();
  bool showCustomKeyboard = false;

  // Méthode pour sauvegarder une transaction dans Firestore
// Méthode pour sauvegarder une transaction dans Firestore
// Méthode pour sauvegarder une transaction dans Firestore
Future<void> _saveTransaction(double amount, String type) async {
  final transaction = {
    "amount": amount,
    "type": type,  // "Débit" ou "Crédit" selon le type de transaction
    "phoneNumber": widget.phoneNumber,
    "date": DateTime.now(),
  };

  try {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(widget.phoneNumber);
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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
    );
  }
}


  Widget _buildCustomKeyboard() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '⌫'];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              if (key == '⌫') {
                if (amountController.text.isNotEmpty) {
                  amountController.text = amountController.text
                      .substring(0, amountController.text.length - 1);
                }
              } else if (key == '.' && amountController.text.contains('.')) {
                return;
              } else {
                amountController.text += key;
              }
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              key,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Orange-Money-logo.png',
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Numéro à débiter',
                style: TextStyle(fontSize: 10),
              ),
              const SizedBox(height: 2),
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showCustomKeyboard = true;
                  });
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.none,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      hintText: 'Saisir le montant (GNF)',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 18,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Frais opérateur', style: TextStyle(fontSize: 16)),
                        Text('-', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Montant à recevoir',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          '-',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final amount = amountController.text.trim();

                  if (amount.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez entrer un montant'),
                      ),
                    );
                    return;
                  }

                  final amountValue = double.tryParse(amount);
                  if (amountValue == null || amountValue <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez entrer un montant valide'),
                      ),
                    );
                    return;
                  }

                  // Enregistrer la transaction
                  await _saveTransaction(amountValue, "Crédit");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Confirmer',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              if (showCustomKeyboard)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _buildCustomKeyboard(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
