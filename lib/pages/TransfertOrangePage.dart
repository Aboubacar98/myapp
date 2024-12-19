import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/widgets/ShowAppel.dart';
import 'package:myapp/widgets/ShowPinDialog.dart';

class TransfertOrangePage extends StatefulWidget {
  @override
  _TransfertOrangePageState createState() => _TransfertOrangePageState();
}

class _TransfertOrangePageState extends State<TransfertOrangePage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool isPhoneValid = false;
  int frais = 0;
  String errorMessage = '';

  void validatePhoneNumber(String value) {
    setState(() {
      isPhoneValid = RegExp(r'^(62|65|66)\d{7}$').hasMatch(value);
    });
  }

  void calculateFrais(String value) {
    if (value.isEmpty) {
      setState(() {
        frais = 0;
        errorMessage = '';
      });
      return;
    }

    final montant = int.tryParse(value) ?? 0;

    if (montant < 10000) {
      setState(() {
        errorMessage =
            "Le montant minimum pour un transfert est de 10 000 GNF.";
        frais = 0;
      });
    } else {
      setState(() {
        errorMessage = '';
        if (montant <= 50000) {
          frais = 1000;
        } else if (montant <= 100000) {
          frais = 2000;
        } else if (montant <= 200000) {
          frais = 3000;
        } else if (montant <= 500000) {
          frais = 5000;
        } else if (montant <= 1000000) {
          frais = 8000;
        } else {
          frais = 10000;
        }
      });
    }
  }

  void appendToAmount(String value) {
    setState(() {
      _amountController.text += value;
      calculateFrais(_amountController.text);
    });
  }

  void removeLastCharacterFromAmount() {
    setState(() {
      if (_amountController.text.isNotEmpty) {
        _amountController.text = _amountController.text
            .substring(0, _amountController.text.length - 1);
        calculateFrais(_amountController.text);
      }
    });
  }

  void showPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowPinDialog(); // Assurez-vous que ShowPinDialog est un widget valide
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Transfert vers Orange Money",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Image.asset(
              'assets/images/mobile-money.png',
              width: 40,
              height: 40,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Champ de saisie pour le numéro
              TextField(
                controller: _phoneController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixText: "+224 ",
                  prefixStyle: TextStyle(color: Colors.black),
                  hintText: "Numéro de téléphone",
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.person, color: Colors.blue),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: validatePhoneNumber,
              ),
              SizedBox(height: 16),
              // Champ de saisie pour le montant (affiché seulement si le numéro est valide)
              if (isPhoneValid)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _amountController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Montant",
                        labelStyle: TextStyle(color: Colors.black),
                        suffixText: "GNF",
                        suffixStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      onChanged: calculateFrais,
                    ),
                    const SizedBox(height: 8),
                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    if (errorMessage.isEmpty)
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            "Frais : $frais GNF",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                  ],
                ),
              SizedBox(height: 16),
              // Boutons Annuler et Valider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    child: Text("Annuler"),
                  ),
                  ElevatedButton(
                    onPressed: (isPhoneValid && errorMessage.isEmpty)
                        ? () {
                            // Appeler showPinDialog ici avec le BuildContext
                            showPinDialog(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text("Valider"),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Clavier numérique
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  if (index == 9) {
                    return Container();
                  } else if (index == 10) {
                    return TextButton(
                      onPressed: () => appendToAmount("0"),
                      child: Text("0", style: TextStyle(color: Colors.black)),
                    );
                  } else if (index == 11) {
                    return IconButton(
                      icon: Icon(Icons.backspace, color: Colors.blue),
                      onPressed: removeLastCharacterFromAmount,
                    );
                  } else {
                    return TextButton(
                      onPressed: () => appendToAmount((index + 1).toString()),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}