import 'package:flutter/material.dart';
import 'package:myapp/pages/widgets/card_required.dart';

class DepotPage extends StatefulWidget {
  const DepotPage({super.key});

  @override
  State<DepotPage> createState() => _DepotPageState();
}

class _DepotPageState extends State<DepotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Faire un dépôt via",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardRequired(
              icon: Image.asset('assets/Orange-Money-logo.png'),
              title: 'Orange Money',
              subtitle: 'Premier dépôt gratuit',
            ),
            const SizedBox(
              height: 10,
            ),
            CardRequired(
              icon: Image.asset('assets/mobile-money.png'),
              title: 'Mobile Money',
              subtitle: 'Premier dépôt gratuit',
            ),
            const SizedBox(
              height: 10,
            ),
            CardRequired(
              icon: Image.asset('assets/Moneygram.png'),
              title: 'Moneygram',
              subtitle: 'Premier dépôt gratuit',
            ),
          ],
        ),
      ),
    );
  }
}
