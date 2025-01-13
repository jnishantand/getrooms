import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getroom/Auth/Login/login.dart';
import 'package:getroom/pages/home/menu/settings.dart';
import 'package:google_sign_in/google_sign_in.dart';


class FirebaseLogin {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseLogin _instance = FirebaseLogin._internal();

  factory FirebaseLogin() {
    return _instance;
  }

  FirebaseLogin._internal();

  Future<void> GoogleLogin(BuildContext context) async {
    final user = await signInWithGoogle();
    if (user != null) {
      print('Signed in as: ${user.displayName}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('hii ${user.displayName}'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      await fetchData(user.email!).then((val) {
        if (val != null && val == true) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome back! ${user.displayName}'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
          });
         _handleLogin(LoginType.google);

        } else {
          saveData(
              uname: user.displayName.toString(),
              email: user.email.toString(),
              context: context)
              .then((res) {
            // Get.offAll(ShoppingHomeScreen(user: user));
          });
        }
      });
    } else {
      print('Google sign-in failed.');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication dialog
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Retrieve the Google sign-in authentication details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the signed-in user
      return userCredential.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<bool?> saveData(
      {required String uname,
        required String email,
        required BuildContext context}) async {
    try {
      // Reference to a Firestore collection
      CollectionReference users = _firestore.collection('users');

      // Adding a new document with some data
      await users.add({
        'name': '${uname}',
        'email': '${email}',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("Data saved successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data saved successfully!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      return true;
    } catch (e) {
      print("Error saving data: $e");
      return null;
    }
  }

  Future<bool?> fetchData(String email) async {
    try {
      // Reference to the 'users' collection
      CollectionReference users = _firestore.collection('users');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await users.get();

      final list = querySnapshot.docs
          .map((data) => data['email'] == "${email}")
          .toList();

      if (list.any((data) => data == true)) {
        debugPrint("njdebug:matched email");
        return true;
      } else {
        debugPrint("njdebug: not matched email");
        return false;
      }
    } catch (e) {
      print("Error fetching data: $e");
      return false;
    }
  }
  Future<void> _handleLogin(LoginType loginType) async {
    switch (loginType) {
      case LoginType.normal:
        print("Perform normal login");
        await localStorage.setLoggedIn(true);
        Get.toNamed('/home');
        break;

      case LoginType.facebook:
        print("Perform Facebook login");
        // Implement Facebook login logic here
        break;

      case LoginType.google:
        await localStorage.setLoggedIn(true);
        Get.toNamed('/home');
        break;
    }
  }

}
