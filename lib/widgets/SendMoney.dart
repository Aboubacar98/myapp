import 'package:flutter/material.dart';
import 'package:myapp/widgets/card_required.dart';
import 'package:myapp/widgets/receive.dart';

class Sendmoney extends StatefulWidget {
  const Sendmoney({super.key});

  @override
  State<Sendmoney> createState() => _SendmoneyState();
}

class _SendmoneyState extends State<Sendmoney> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Envoyer de l'argent",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
            ),
            CardRequired(
              icon: Image.asset('assets/images/Orange-Money-logo.png'),
              title: "Orange Money",
              subtitle: "Tranfert vers Orange Money",
              trailingIcon: Icons.chevron_right,
              onTrailingPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Receiver(),
                    ));
              },
            ),
            CardRequired(
              icon: Image.asset('assets/images/mobile-money.png'),
              title: 'Mobile Money',
              subtitle: " Tranfert vers Mobile Money",
              trailingIcon: Icons.chevron_right,
              onTrailingPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Receiver(),
                  ),
                );
              },
            ),
            CardRequired(
              icon: Image.asset('assets/images/moneygram.png'),
              title: 'Moneygram',
              subtitle: "Tranfert vers Moneygram",
              trailingIcon: Icons.chevron_right,
              onTrailingPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Receiver(),
                  ),
                );
              },
            ),
          ],
        ), 
      ),
    );
  }
}
