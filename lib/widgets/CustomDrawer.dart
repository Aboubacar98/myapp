import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/AlertePage.dart';
import 'package:myapp/widgets/AccountBonus.dart';
import 'package:myapp/widgets/RelayPoints.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? userName;
  String? userEmail;
  String? userPhone;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Récupération des données utilisateur depuis Firestore
  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          if (mounted) {
            setState(() {
              userName = userDoc.data()?['name'] ?? 'Utilisateur';
              userEmail = user.email;
              userPhone = userDoc.data()?['phone'] ?? '+000 000 000 000';
            });
          }
        }
      } catch (e) {
        print('Erreur lors de la récupération des données utilisateur : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header Section
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            accountName: Text(
              userName ?? 'Chargement...',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              userPhone ?? '+000 000 000 000',
              style: TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/profile_picture.jpg'), // Assurez-vous que le chemin est correct.
            ),
            otherAccountsPictures: [
              IconButton(
                onPressed: () {
                  // Action pour éditer la photo
                },
                icon: Icon(Icons.camera_alt, color: Colors.blue),
              )
            ],
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet,
                      color: Colors.blue),
                  title: const Text('Mon Numéro de compte'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: const Text('Boîte de réception'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AlertePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.card_giftcard, color: Colors.blue),
                  title: const Text('Compte bonus'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountBonus()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.store, color: Colors.blue),
                  title: const Text('Points relais'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RelayPointsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.headset_mic, color: Colors.blue),
                  title: const Text('Aide'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.lock, color: Colors.blue),
                  title: const Text('Verrouiller'),
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Footer Section
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Gagnez 10.000 GNF par invité 🎉',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Vous recevrez 10.000 GNF la première fois que votre invité effectue un paiement avec l\'application.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Code de parrainage : ASZ1O7',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Action pour inviter un ami
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                  ),
                  child: Text('Inviter un ami'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
