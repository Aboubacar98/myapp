import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllFrequentQuestionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions fréquentes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('search_queries')
              .where('frequency', isGreaterThanOrEqualTo: 3)
              .orderBy('frequency', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('Aucune question fréquente pour le moment.');
            }

            final queries = snapshot.data!.docs;
            final displayedQueries = <String>{};

            return ListView(
              children: queries.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                if (displayedQueries.contains(data['query'])) {
                  return Container(); // Ignore les doublons
                }
                displayedQueries.add(data['query']);
                return ListTile(
                  title: Text(data['query']),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Action pour ouvrir une réponse détaillée
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}