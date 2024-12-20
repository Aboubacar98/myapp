import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BoxObjectif extends StatefulWidget {
  final String nomCompte;

  const BoxObjectif({Key? key, required this.nomCompte}) : super(key: key);

  @override
  State<BoxObjectif> createState() => _BoxObjectifState();
}

class _BoxObjectifState extends State<BoxObjectif> {
  DateTime? selectedDate;
  bool isLocked = false;
  TextEditingController montantController = TextEditingController();

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
        // Ajout du SingleChildScrollView pour éviter les débordements
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Fixez-vous un objectif",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Donnez-vous une échéance et un objectif. \n"
                      "Nous vous aiderons à l'atteindre",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Echéance et date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Échéance",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Colors.blue,
                              hintColor: Colors.blue,
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate != null
                                ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                                : "Sélectionnez une date",
                            style: TextStyle(
                              color: selectedDate != null
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15), // Réduction de l'espacement
              // Montant avec préfixe GNF
              const Text(
                "Montant",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: montantController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    suffixText: 'GNF ',
                    suffixStyle: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    hintText: 'Entrez un montant',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
              const SizedBox(height: 15), // Réduction de l'espacement
              // Coffre bloqué
              Row(
                children: [
                  const Icon(Icons.lock, color: Colors.blue),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Caisse bloquée",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Bloquer la caisse jusqu'à l'échéance",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Transform.scale(
                    // Permet de redimensionner le switch
                    scale: 0.8, // Redimensionnement du Switch
                    child: Switch(
                      value: isLocked,
                      onChanged: (value) {
                        setState(() {
                          isLocked = value;
                        });
                        // Action déclenchée lors du verrouillage
                        if (isLocked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Caisse verrouillée")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Caisse déverrouillée")),
                          );
                        }
                      },
                      activeColor: Colors.blue, // Icône de switch en bleu
                      inactiveThumbColor:
                          Colors.white, // Icône de switch en blanc
                      inactiveTrackColor:
                          Colors.grey[300], // Piste du switch en gris clair
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espacement avant le bouton
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Action pour le bouton "Suivant"
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
}
