import 'package:flutter/material.dart';
import 'package:myapp/services/authentification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final Authentification _auth = Authentification();

  String _errorMessage = "";

  // Fonction pour gérer l'inscription
  Future<void> _signup() async {
  setState(() {
    _errorMessage = "";
  });

  // Vérification des champs
  if (_nameController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _phoneController.text.isEmpty ||
      _passwordController.text.isEmpty) {
    setState(() {
      _errorMessage = "Tous les champs doivent être remplis.";
    });
    return;
  }

  if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
    setState(() {
      _errorMessage = "Veuillez entrer un email valide.";
    });
    return;
  }

  if (_passwordController.text.length < 6) {
    setState(() {
      _errorMessage = "Le mot de passe doit contenir au moins 6 caractères.";
    });
    return;
  }

  // Appeler le service d'inscription
  String res = await _auth.signupUser(
    email: _emailController.text,
    password: _passwordController.text,
    name: _nameController.text,
    phone: _phoneController.text,
  );
  

  if (res == "success") {
    // Inscription réussie, naviguer immédiatement
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    // Gestion des erreurs
    setState(() {
      _errorMessage = res;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Conteneur personnalisé avec un bouton de retour en haut à gauche
            Container(
              height: mediaQuery.height * 0.25,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(70)),
                gradient: LinearGradient(
                  colors: [Colors.blue, Color.fromARGB(255, 114, 149, 243)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Bouton de retour en haut à gauche
                  Positioned(
                    top: 40, // Ajuster la position selon le besoin
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Retour à l'écran précédent
                      },
                    ),
                  ),
                  const Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "YIGUIPAY",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 5,
                    right: 20,
                    child: Text(
                      "Inscription",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // Nom Complet
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      labelText: "Nom Complet",
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Email
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      labelText: "Entrer votre email",
                      icon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Numéro de téléphone
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      labelText: "Numéro de téléphone",
                      icon: Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Mot de passe
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      labelText: "Mot de passe",
                      icon: const Icon(
                        Icons.vpn_key,
                        color: Colors.blue,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bouton d'inscription
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    child: const Text(
                      "S'inscrire",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _signup,
                  ),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                          color: _errorMessage == "Inscription réussie !"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
