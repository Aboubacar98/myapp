import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebitNumberPage extends StatefulWidget {
  final String phoneNumber; // Numéro transmis depuis DebitPage

  const DebitNumberPage({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _DebitNumberPageState createState() => _DebitNumberPageState();
}

class _DebitNumberPageState extends State<DebitNumberPage> {
  final TextEditingController amountController = TextEditingController();
  bool showCustomKeyboard = false; // Contrôle l'affichage du pavé numérique

  // Méthode pour afficher le pavé numérique personnalisé
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
                // Ne pas autoriser plusieurs points décimaux
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
              'assets/images/Orange-Money-logo.png', // Chemin vers le logo
              height: 40, // Taille du logo
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
              // Texte pour le numéro à débiter
              const Text(
                'Numéro à débiter',
                style: TextStyle(
                  fontSize: 10,
                ),
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

              // Champ de saisie pour le montant avec pavé numérique personnalisé
              GestureDetector(
                onTap: () {
                  setState(() {
                    showCustomKeyboard = true; // Affiche le pavé numérique
                  });
                },
                child: AbsorbPointer(
                  // Empêche l'affichage du clavier natif
                  child: TextField(
                    controller: amountController,
                    keyboardType:
                        TextInputType.none, // Désactive le clavier natif
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

              // Frais opérateur et montant à recevoir (visible même si le clavier est activé)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Frais opérateur',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '-',
                          style: TextStyle(fontSize: 16),
                        ),
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

              // Bouton Confirmer
              ElevatedButton(
                onPressed: () {
                  final amount = amountController.text.trim();
                  if (amount.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez entrer un montant'),
                      ),
                    );
                    return;
                  }

                  // Logique pour confirmer le montant
                  print('Montant confirmé : $amount');
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

              // Pavé numérique personnalisé
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
