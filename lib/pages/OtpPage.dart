import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'home_page.dart'; // Assurez-vous d'importer la page d'accueil

class OtpPage extends StatefulWidget {
  final double amount;
  const OtpPage({super.key, required String otp, required this.amount});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  late Timer _timer;
  int _secondsRemaining = 30;

  bool _isLoading = false; // Pour afficher un état de chargement
  bool _isOtpValid = false; // Pour désactiver les champs après validation

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  // Fonction pour valider l'OTP
  void _validateOtp() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // Simuler un appel réseau

    final otp = _controllers.map((controller) => controller.text).join();
    if (otp == "1234") {
      setState(() {
        _isOtpValid = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Code valide ! Transaction confirmée."),
          backgroundColor: Colors.green,
        ),
      );

      // Enregistrer la transaction dans Firestore
      await _saveTransaction();

      // Redirection vers la page d'accueil
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomePage()), // Remplacez par votre page d'accueil
        );
      });
    } else {
      _triggerErrorFeedback();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Code incorrect. Réessayez."),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Fonction pour le feedback haptique
  void _triggerErrorFeedback() {
    HapticFeedback.vibrate();
  }

  // Vérifie si tous les champs sont remplis
  bool _areFieldsFilled() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  // Fonction pour enregistrer la transaction dans Firestore
  Future<void> _saveTransaction() async {
    final transactionData = {
      "amount": widget.amount, // Remplacer par le montant réel de la transaction
      "type": "Crédit", // Remplacer par le type de transaction (Crédit/Débit)
      "phoneNumber":
          "1234567890", // Remplacer par le numéro de téléphone de l'utilisateur
      "date": DateTime.now(),
    };

    try {
      // Ajouter la transaction dans Firestore
      await FirebaseFirestore.instance
          .collection('transactions')
          .add(transactionData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction enregistrée avec succès !')),
      );
    } catch (e) {
      print("Erreur lors de l'enregistrement de la transaction: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Code temporaire",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Veuillez entrer le code que vous avez reçu par SMS",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: _controllers[index],
                    enabled:
                        !_isOtpValid, // Désactive les champs après validation
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _isOtpValid ? Colors.green : Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }

                      if (_areFieldsFilled()) {
                        _validateOtp();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _areFieldsFilled() ? _validateOtp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Valider",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Vous n'avez pas reçu de code ? ",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: _secondsRemaining == 0
                      ? () {
                          setState(() {
                            _secondsRemaining = 30;
                            _startTimer();
                          });
                        }
                      : null,
                  child: Text(
                    _secondsRemaining == 0
                        ? "Renvoyer"
                        : "Renvoyer dans 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: _secondsRemaining == 0 ? Colors.blue : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
