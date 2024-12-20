import 'package:flutter/material.dart';
import 'package:myapp/pages/BoxObjectif.dart';

class BoxPage extends StatefulWidget {
  const BoxPage({Key? key}) : super(key: key);

  @override
  State<BoxPage> createState() => _BoxPageState();
}

class _BoxPageState extends State<BoxPage> {
  String? selectedCategory;
  TextEditingController textController = TextEditingController();

  // Map pour définir des icônes spécifiques pour chaque catégorie
  final Map<String, IconData> categoryIcons = {
    "Imprévus": Icons.warning_amber_rounded,
    "Études": Icons.school,
    "Vacances": Icons.beach_access,
    "Donations": Icons.volunteer_activism,
    "Cadeau": Icons.card_giftcard,
    "Travail": Icons.work,
    "Famille": Icons.family_restroom,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        selectedCategory != null
                            ? categoryIcons[selectedCategory] ?? Icons.category
                            : Icons.category, // Icône par défaut
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Pourquoi créez-vous cette caisse?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textController,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value.isNotEmpty ? value : null;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Nom du compte",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCategoryChip("Imprévus"),
                  _buildCategoryChip("Études"),
                  _buildCategoryChip("Vacances"),
                  _buildCategoryChip("Donations"),
                  _buildCategoryChip("Cadeau"),
                  _buildCategoryChip("Travail"),
                  _buildCategoryChip("Famille"),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (textController.text.isNotEmpty ||
                          selectedCategory != null)
                      ? () {
                          // Naviguer vers BoxObjectif et passer le nom du compte
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoxObjectif(
                                nomCompte: textController.text, // Passer le nom du compte
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (textController.text.isNotEmpty ||
                            selectedCategory != null)
                        ? Colors.blue
                        : Colors.blue[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Suivant",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
          textController.text = label; // Met à jour le champ de texte
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.blue[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
