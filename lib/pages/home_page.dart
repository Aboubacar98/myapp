import 'package:flutter/material.dart';

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
    const AccountPage(),   // Page Compte
    const SavingsPage(),   // Page Épargne
    const CardsPage(),     // Page Cartes
    const StatsPage(),     // Page Statistiques
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _pages[_selectedIndex], // Change le contenu selon l'onglet sélectionné
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Assure que tous les labels s'affichent
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
        unselectedItemColor: Colors.grey, // Couleur des éléments non sélectionnés
        onTap: _onItemTapped, // Appel à la fonction de changement d'onglet
      ),
    );
  }
}

// Widget pour la page Compte
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone de solde rapide
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Votre solde',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const Text(
                      '15,230.00 GNF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "Ajouter de l'argent",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Transactions récentes
            const Text(
              "Transactions récentes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 200, // Définir une hauteur pour la liste
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.account_balance_wallet),
                      title: Text('Transfert reçu'),
                      subtitle: Text('2 500 GNF'),
                      trailing: Text('12 Oct, 2024'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text('Achat en ligne'),
                      subtitle: Text('5 000 GNF'),
                      trailing: Text('10 Oct, 2024'),
                    ),
                  ),
                  // Ajoutez d'autres transactions ici
                ],
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Opérations",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                InkWell(
                  onTap: () {},
                  child: _buildActionButton(
                      "Transfert d'argent", Icons.swap_horiz, Colors.orange),
                ),
                InkWell(
                  onTap: () {},
                  child: _buildActionButton(
                      'Recharger mon compte',
                      Icons.add_circle_outline_sharp,
                      const Color.fromARGB(255, 83, 76, 175)),
                ),
                InkWell(
                  onTap: () {},
                  child: _buildActionButton(
                      'Investir', Icons.show_chart, Colors.blue),
                ),
                InkWell(
                  onTap: () {},
                  child: _buildActionButton(
                      'Factures', Icons.receipt_long, Colors.purple),
                ),
                InkWell(
                  onTap: () {},
                  child: _buildActionButton(
                      'Change', Icons.currency_exchange, Colors.teal),
                ),
                InkWell(
                  onTap: () {},
                  child: _buildActionButton("Retrait d'argent",
                      Icons.shape_line_outlined, Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildActionButton(String title, IconData icon, Color color) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      const SizedBox(height: 8),
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}

// Page Épargne
class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Bienvenue sur la page Épargne",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Page Cartes
class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Bienvenue sur la page Cartes",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Page Statistiques
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Bienvenue sur la page Statistiques",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
