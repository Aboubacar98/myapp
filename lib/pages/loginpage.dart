import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/pages/signUpscreen.dart';
import 'package:myapp/services/authentification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Contrôleurs de texte pour les champs de saisie
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Authentification _authMethod = Authentification();

  String _errorMessage = ""; // Pour afficher les erreurs

  // Fonction pour gérer la connexion
  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Appeler la méthode loginUser de Authentification
    String res = await _authMethod.loginUser(email: email, password: password);

    if (res == "success") {
      // Si la connexion est réussie, naviguer vers l'écran principal (exemple : Home)
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Si l'authentification échoue, afficher un message d'erreur
      setState(() {
        _errorMessage = res;
      });
    }
  }

  // Pour les autres options de connexion (Google, Facebook, Apple)
  Future<void> _signInWithGoogle() async {}
  Future<void> _signInWithFacebook() async {}
  Future<void> _signInWithApple() async {}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête avec le dégradé
            Container(
              height: mediaQuery.height * 0.25,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70)),
                gradient: LinearGradient(
                  colors: [Colors.blue, Color.fromARGB(255, 114, 149, 243)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Stack(
                children: [
                  Positioned(
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
                  Positioned(
                    bottom: 5,
                    right: 20,
                    child: Text(
                      "Connexion",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Titre
            const Text(
              "Bienvenue sur YIGUI",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // Champ Email
                  TextField(
                    controller: _emailController, // Contrôleur pour l'email
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      hintText: "Email",
                      icon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Champ Mot de passe
                  TextField(
                    controller: _passwordController, // Contrôleur pour le mot de passe
                    obscureText: true, // Cacher le mot de passe
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      hintText: "Mot de passe",
                      icon: Icon(
                        Icons.vpn_key,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  // Affichage du message d'erreur si nécessaire
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Bouton "Se connecter"
                  ElevatedButton(
                    onPressed: _login, // Appeler la méthode de connexion
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Boutons de connexion avec d'autres plateformes
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    icon: SvgPicture.asset(
                      'assets/images/icon-google.svg',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      "Continuer avec Google",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: _signInWithGoogle,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    icon: const Icon(Icons.facebook, color: Colors.white),
                    label: const Text(
                      "Continuer avec Facebook",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _signInWithFacebook,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    icon: const Icon(Icons.apple, color: Colors.white),
                    label: const Text(
                      "Continuer avec Apple",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _signInWithApple,
                  ),
                  const SizedBox(height: 20),
                  // Lien vers l'inscription
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Vous n'avez pas de compte?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          " Créez-en !",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
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
