import 'package:flutter/material.dart';

class ShowPinDialog extends StatefulWidget {
  const ShowPinDialog({super.key});

  @override
  State<ShowPinDialog> createState() => _ShowPinDialogState();
}

class _ShowPinDialogState extends State<ShowPinDialog> {
  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text("Entrez votre pin"),
      content: TextField(
        obscureText: true,
      ),
    );
  }
}
