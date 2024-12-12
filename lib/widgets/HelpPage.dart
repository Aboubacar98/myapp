import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/CategoryButton.dart';
import 'package:myapp/pages/AllQuestionPage.dart';

class HelpPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Besoin d'aide?"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher des réponses...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    _saveSearchQuery(query);
                  }
                },
              ),
              const SizedBox(height: 24),
              // Section Contactez-nous
              const Text(
                'Contactez-nous',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.call, color: Colors.white),
                ),
                title: const Text('Appeler le service client'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Action pour appeler
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.chat, color: Colors.white),
                ),
                title: const Text('Chatter avec le support'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Action pour chatter
                },
              ),
              const SizedBox(height: 24),
              // Section Questions fréquentes avec "Voir tout"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Questions fréquentes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllFrequentQuestionsPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFrequentQuestions(context, limit: 5),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sélectionner une catégorie",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CategoryButton(
                          icon: Icons.rocket,
                          label: 'Commencer',
                          onPressed: () {},
                        ),
                        CategoryButton(
                          icon: Icons.swap_horiz,
                          label: 'Problèmes de transaction',
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Sauvegarde une recherche dans Firestore
  Future<void> _saveSearchQuery(String query) async {
    final collection = FirebaseFirestore.instance.collection('search_queries');
    final doc = collection.doc(query);

    // Vérifie si le document existe
    final snapshot = await doc.get();
    if (snapshot.exists) {
      // Incrémente le compteur
      doc.update({'frequency': FieldValue.increment(1)});
    } else {
      // Crée un nouveau document
      doc.set({'query': query, 'frequency': 1});
    }
  }

  /// Construit la liste des questions fréquentes
  Widget _buildFrequentQuestions(BuildContext context, {int? limit}) {
    Query query = FirebaseFirestore.instance
        .collection('search_queries')
        .where('frequency', isGreaterThanOrEqualTo: 3)
        .orderBy('frequency', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('Aucune question fréquente pour le moment.');
        }

        final queries = snapshot.data!.docs;
        final displayedQueries = <String>{};

        return Column(
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
    );
  }
}
