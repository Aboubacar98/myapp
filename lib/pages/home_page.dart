import 'package:flutter/material.dart';
import 'package:myapp/pages/AccountPage.dart';
import 'package:myapp/pages/AlertePage.dart';
import 'package:myapp/pages/CardsPage.dart';
import 'package:myapp/pages/SavingsPage.dart';
import 'package:myapp/pages/StatsPage.dart';
import 'package:myapp/widgets/CustomDrawer.dart';
import 'package:myapp/widgets/ShowAppel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Fonction pour changer l'index lors de la sélection d'un onglet
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Liste des widgets pour chaque onglet
  final List<Widget> _pages = [
    const AccountPage(), // Page Compte
    const SavingsPage(), // Page Épargne
    const CardsPage(), // Page Cartes
    const StatsPage(), // Page Statistiques
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "YiGuiPay",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        /*leading: IconButton(
          onPressed: () {
          },
          icon: const Icon(Icons.menu),
        ),*/
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3008061591.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlertePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        height: 250,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Mon Conseiller Financier",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.phone),
                              ),
                              title: const Text(
                                "Contactez un Conseiller",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: const Text("8h à 17h",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  )),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.pop(
                                    context); // Ferme le premier bottom sheet
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ShowCall(); // Appel du widget ShowCall ici
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.chat_bubble_outline),
                              ),
                              title: const Text(
                                "Chatter avec un Conseiller",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: const Text("8h à 17h",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  )),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _pages[
          _selectedIndex], // Change le contenu selon l'onglet sélectionné
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // Assure que tous les labels s'affichent
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Compte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Épargne',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cartes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
        ],
        currentIndex: _selectedIndex, // Index actif
        selectedItemColor: Colors.blue, // Couleur de l'élément sélectionné
        unselectedItemColor:
            Colors.grey, // Couleur des éléments non sélectionnés
        onTap: _onItemTapped, // Appel à la fonction de changement d'onglet
      ),
    );
  }
}
