import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    log('Building Login Screen...');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: isLoading == true
            ? Image.asset("assets/icons/loading-gif.gif",color: Colors.red,)
            : Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      isLoading = true;
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      log('Google Sign-In button pressed.');

                      try {
                        // Attempt Google Sign-In
                        UserCredential userCredential =
                            await signInWithGoogle();

                        log('Google Sign-In successful.');

                        // Obtain the ID Token
                        final String? idToken =
                            await userCredential.user?.getIdToken();

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
                          await prefs.setString(
                              "email", "${userCredential.user?.email}");

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          isLoading = false;
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
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        UserCredential facebookAuthCredential =
                            await signInWithFacebook();
                        log("--------------------------------facebook ${facebookAuthCredential.additionalUserInfo?.username}");
                        log("--------------------------------facebook ${facebookAuthCredential.user!.email}");
                        log("--------------------------------facebook ${facebookAuthCredential.additionalUserInfo?.username}");
                      },
                      child: Text("Facebook LogIn"))
                ],
              ),
      ),
    );
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
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
