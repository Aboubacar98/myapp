import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override



  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Ajout de centerTitle pour centrer le logo/text
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
          backgroundColor: Colors.white, // Pour un fond plus neutre et propre
          elevation: 0, // Supprimer l'ombre pour un look plus plat
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Zone de solde rapide
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
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
                        child: const Text("Ajouter de l'argent",
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
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.account_balance_wallet),
                        title: const Text('Transfert reçu'),
                        subtitle: const Text('2 500 GNF'),
                        trailing: const Text('12 Oct, 2024'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: const Text('Achat en ligne'),
                        subtitle: const Text('5 000 GNF'),
                        trailing: const Text('10 Oct, 2024'),
                      ),
                    ),
                    // Ajoutez d'autres transactions ici
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
