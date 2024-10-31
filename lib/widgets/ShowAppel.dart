import 'package:flutter/material.dart';

class ShowCall extends StatelessWidget {
  const ShowCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              height: 100,
              //width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2685027846.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1153524964.
                  children: [
                    Icon(Icons.phone, color: Colors.blue, size: 50),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Appeler 8080",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                        ))
                  ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              height: 100,
              //width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    textAlign: TextAlign.center,
                    "Annuler",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
