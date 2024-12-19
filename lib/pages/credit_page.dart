import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/Cr%C3%A9ditNumberPage.dart';
import 'package:myapp/pages/OtpPage.dart';

class CreditPage extends StatelessWidget {
  final String subtitle;
  static const String defaultOTP = "1234";

  const CreditPage({super.key, required this.subtitle});

  // Méthode pour obtenir le numéro de téléphone de l'utilisateur
  Future<String> getUserPhoneNumber() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Utilisateur non connecté");
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception("Données utilisateur introuvables");
    }

    return userDoc.data()?['phone'] ?? "Numéro non défini";
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    bool isPhoneValid = false;

    void validatePhoneNumber(String value, Function setState) {
      if (value.length == 9 && value.startsWith("62")) {
        setState(() => isPhoneValid = true);
      } else {
        setState(() => isPhoneValid = false);
      }
    }

    void showCustomDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Tapez le numéro de rechargement"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        decoration: const InputDecoration(
                          hintText: "0X XX XX XX XX",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        onChanged: (value) {
                          validatePhoneNumber(value, setState);
                        },
                      ),
                      const SizedBox(height: 12),
                      if (isPhoneValid) ...[
                        const Text("Entrez le montant"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            hintText: "Montant en GNF",
                            suffixText: "GNF ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(
                                () {}); // Met à jour le bouton dynamiquement
                          },
                        ),
                      ],
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.amber[100],
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline, color: Colors.black),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: [
                                    TextSpan(
                                        text:
                                            'Veuillez vérifier le numéro avant de cliquer sur '),
                                    TextSpan(
                                      text: 'Confirmer.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                        text:
                                            ' Vous ne pourrez pas le modifier avant '),
                                    TextSpan(
                                      text: '15 jours.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Annuler",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (isPhoneValid &&
                            amountController.text.isNotEmpty)
                        ? () {
                            // Récupération dynamique du montant saisi
                            final double? amount =
                                double.tryParse(amountController.text.trim());

                            if (amount != null) {
                              // Vérifie si la conversion a réussi
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpPage(
                                    otp: defaultOTP,
                                    amount:
                                        amount, // Passe le montant dynamique ici
                                  ),
                                ),
                              );
                            } else {
                              // Affiche une erreur si la conversion échoue
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Montant invalide. Veuillez entrer un nombre."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text("Confirmer"),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choisissez le numéro à débiter",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            wordSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: getUserPhoneNumber(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur: ${snapshot.error}"));
                } else {
                  final phoneNumber = snapshot.data ?? "";
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/profile.png'),
                        radius: 20,
                      ),
                      title: const Text(
                        "Utiliser mon numéro",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(phoneNumber),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.blue, size: 14),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreditNumberPage(phoneNumber: phoneNumber),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: IconButton(
                    onPressed: showCustomDialog,
                    icon: const Icon(Icons.add, color: Colors.blue),
                  ),
                ),
                title: const Text(
                  "Ajouter un numéro de dépôt",
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
