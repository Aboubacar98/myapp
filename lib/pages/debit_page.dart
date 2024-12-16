import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/DebitNumberPage.dart';

class DebitPage extends StatelessWidget {
  final String subtitle; // Paramètre pour le subtitle

  const DebitPage({super.key, required this.subtitle});

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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: getUserPhoneNumber(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Erreur: ${snapshot.error}"),
                  );
                } else {
                  final phoneNumber = snapshot.data ?? "";
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/profile.png'), // Remplacez avec une image par défaut
                        radius: 20,
                      ),
                      title: const Text(
                        "Utiliser mon numéro",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(phoneNumber),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DebitNumberPage(
                              phoneNumber: phoneNumber,
                            ),
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
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                content: Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Tapez le numéro de rechargement"),
                                      SizedBox(height: 8),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "0X XX XX XX XX",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 2.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        color: Colors.amber[100],
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.info_outline,
                                                color: Colors.black),
                                            SizedBox(width: 8.0),
                                            Expanded(
                                                child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(color: Colors.black, fontSize: 14),
                                                children: [
                                                  
                                                ]
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    )),
                title: const Text(
                  "Ajouter un numéro de dépôt",
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  subtitle, // Utilisation du paramètre dynamique
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
