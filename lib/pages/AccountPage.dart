import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/AllTransaction.dart';
import 'package:myapp/pages/depôt_page.dart';
import 'package:myapp/widgets/SendMoney.dart';

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
            // Zone de solde dynamique
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('transactions')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Aucune transaction récente.'),
                  );
                }

                final transactions = snapshot.data!.docs;

                // Calcul du solde
                double balance = 0.0;
                for (var transaction in transactions) {
                  final data = transaction.data() as Map<String, dynamic>;
                  final amount = data['amount'] ?? 0;
                  final type = data['type'] ?? 'Autre';

                  // Ajouter ou soustraire en fonction du type (Débit ou Crédit)
                  if (type == 'Crédit') {
                    balance += amount;
                  } else if (type == 'Débit') {
                    balance -= amount;
                  }
                }

                return Container(
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
                        Text(
                          '${balance.toStringAsFixed(2)} GNF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DepotPage(),
                              ),
                            );
                          },
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
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Transactions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllTransactionsPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Voir tout",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('transactions')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Aucune transaction récente.'),
                    );
                  }

                  final transactions = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final data = transaction.data() as Map<String, dynamic>;

                      final title = data['title'] ?? 'Dépôt';
                      final amount = data['amount'] ?? 0;
                      final date = data['date'] != null
                          ? (data['date'] as Timestamp).toDate()
                          : DateTime.now();
                      final icon = data['icon'] ?? Icons.attach_money.codePoint;
                      final type = data['type'] ?? 'Autre';
                      final phoneNumber = data['phoneNumber'] ?? 'Numéro non disponible';

                      IconData iconData;
                      try {
                        iconData = IconData(icon, fontFamily: 'MaterialIcons');
                      } catch (e) {
                        iconData = Icons.attach_money; // Icône par défaut
                      }

                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              iconData,
                              color: type == 'Débit' ? Colors.red : Colors.green,
                            ),
                          ),
                          title: Text(title),
                          subtitle: Text(
                            '${amount.toString()} GNF\nNuméro: $phoneNumber\n${date.toLocal()}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Opérations
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Sendmoney(),
                      ),
                    );
                  },
                  child: _buildActionButton(
                      "Transfert d'argent", Icons.swap_horiz, Colors.blue),
                ),
                InkWell(
                  onTap: () {},
                  child: _buildActionButton('Recharger mon compte',
                      Icons.add_circle_outline_sharp, Colors.blue),
                ),
                InkWell(
                  onTap: () {},
                  child: _buildActionButton(
                      'Investir', Icons.show_chart, Colors.blue),
                ),
                InkWell(
                  onTap: () {},
                  child: _buildActionButton(
                      'Factures', Icons.receipt_long, Colors.blue),
                ),
                InkWell(
                  onTap: () {},
                  child: _buildActionButton(
                      'Change', Icons.currency_exchange, Colors.teal),
                ),
                InkWell(
                  onTap: () {},
                  child: _buildActionButton("Retrait d'argent",
                      Icons.shape_line_outlined, Colors.blue),
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