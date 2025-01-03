import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_button/src/login.dart';
import 'package:google_button/widget/custom_cache_net_image.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  String? email;
  String? imagePath;

  //
  // await prefs.setString(
  // "imagePath", " ${userCredential.user?.photoURL}");
  // await prefs.setString(
  // "name", " ${userCredential.user?.displayName}");
  // await prefs.setString(
  // "email", " ${userCredential.user?.email}");

  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    imagePath = prefs.getString("imagePath");
    name = prefs.getString("name");
    email = prefs.getString("email");

    log("-----------------------------------------name:$name");
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCachedNetworkImage(
                  height: 50,
                  width: 50,
                  imagePath: '$imagePath',
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("Name: $name"),
                const SizedBox(
                  height: 10,
                ),
                Text("Email:$email"),
              ],
            ),
            IconButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  final GoogleSignIn _googleSignIn = GoogleSignIn();

                  await _googleSignIn.signOut();
                  await prefs.setBool('isLogIn', false);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                icon: const Icon(Icons.logout))
          ],
        ),
      ),
    );
  }
}
