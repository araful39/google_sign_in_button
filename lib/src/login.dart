import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    log('Building Login Screen...');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            log('Google Sign-In button pressed.');

            try {
              // Attempt Google Sign-In
              UserCredential userCredential = await signInWithGoogle();

              log('Google Sign-In successful.');

              // Obtain the ID Token
              final String? idToken = await userCredential.user?.getIdToken();

              if (idToken != null) {
                log("---------------------------------------------------displayName: ${userCredential.user?.displayName}-------------------------------------"); //
                log("---------------------------------------------------email: ${userCredential.user?.email}-------------------------------------"); //
                log("--------------------------------------------------- phoneNumber: ${userCredential.user?.phoneNumber.toString()}-------------------------------------"); //
                log("---------------------------------------------------photoURL: ${userCredential.user?.photoURL}-------------------------------------"); //
                log("---------------------------------------------------uid: ${userCredential.user?.providerData[0]}-------------------------------------"); //

                log("---------------------------------------------------ID Token: $idToken-------------------------------------"); //

                await prefs.setBool('isLogIn', true);
                await prefs.setString(
                    "imagePath", "${userCredential.user?.photoURL}");
                await prefs.setString(
                    "name", "${userCredential.user?.displayName}");
                await prefs.setString("email", "${userCredential.user?.email}");

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                log("ID Token: $idToken"); // Log the token for debugging
              } else {
                log("Failed to retrieve ID Token.");
              }
            } catch (e) {
              log('Google Sign-In failed: $e');

              // Show error dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Sign-In Failed"),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            }
          },
          child: const Text("Google Sign In"),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception("Google Sign-In canceled by user");
      }

      log("Google user signed in: ${googleUser.displayName}");

      // Obtain the Google Sign-In authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential using Google credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the Google credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log("Error during Google Sign-In: $e");
      rethrow; // Propagate error to caller for handling
    }
  }
}
