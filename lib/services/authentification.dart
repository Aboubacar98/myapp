import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentification {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // StreamController pour gérer l'état de l'inscription
  final StreamController<String> _signupStatusController =
      StreamController<String>();

  // Getter pour exposer le stream
  Stream<String> get signupStatusStream => _signupStatusController.stream;

  // Méthode pour inscrire l'utilisateur
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    String res = "Some error occurred";
    try {
      if (password.length < 8) {
        res = "Password should be at least 8 characters";
        return res;
      }
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          name.isNotEmpty &&
          phone.isNotEmpty) {
        // Register user with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user to Firestore
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'id': cred.user!.uid,
          'email': email,
          'phone': phone, // Add phone number to Firestore
        });

        // Emitting success status
        _signupStatusController.sink.add("success");
        res = "success";
      } else {
        res = "Please fill in all fields";
      }
    } catch (err) {
      // Emit error status
      _signupStatusController.sink.addError(err.toString());
      res = err.toString();
    }
    return res;
  }

  // Méthode pour connecter l'utilisateur
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Log the user in with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // Fermer le StreamController lors de la destruction de l'objet
  void dispose() {
    _signupStatusController.close();
  }
}
