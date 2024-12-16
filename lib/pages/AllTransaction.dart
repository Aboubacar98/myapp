import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllTransactionsPage extends StatelessWidget {
  const AllTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes transactions",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              child: Text('Aucune transaction disponible.'),
            );
          }

          final transactions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final data = transaction.data() as Map<String, dynamic>;

              final title = data['title'] ?? 'Transaction';
              final amount = data['amount'] ?? 0;
              final date = data['date'] != null
                  ? (data['date'] as Timestamp).toDate()
                  : DateTime.now();
              final icon = data['icon'] ?? Icons.attach_money.codePoint;
              final type = data['type'] ?? 'Autre';

              IconData iconData;
              try {
                iconData = IconData(icon, fontFamily: 'MaterialIcons');
              } catch (e) {
                iconData = Icons.attach_money; // Icône par défaut
              }

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: type == 'Débit'
                        ? Colors.red.withOpacity(0.2)
                        : Colors.green.withOpacity(0.2),
                    child: Icon(
                      iconData,
                      color: type == 'Débit' ? Colors.red : Colors.green,
                    ),
                  ),
                  title: Text(title),
                  subtitle: Text(
                    '${amount.toString()} GNF\n${date.toLocal()}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
