import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:getroom/Storage/local.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final localStorage = LocalStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Logo
            Center(
              child: SizedBox(height: 150, child: FlutterLogo()),
            ),
            const SizedBox(height: 20),

            // Email TextField
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password TextField
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: () {
                _handleLogin(LoginType.normal);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),

            // Forgot Password
            TextButton(
              onPressed: () {
                Get.toNamed("/forgot-password");
              },
              child: const Text('Forgot Password?'),
            ),
            const SizedBox(height: 20),

            // Social Login Section
            const Divider(thickness: 1),
            const Text(
              'Or login with',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Google Login Button
            ElevatedButton.icon(
              onPressed: () async {
                await _loginWithGoogle(context);
              },
              icon: const Icon(Icons.g_mobiledata),
              label: const Text('Login with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Facebook Login Button
            ElevatedButton.icon(
              onPressed: () async {
                //   await _loginWithFacebook(context);
              },
              icon: const Icon(Icons.facebook),
              label: const Text('Login with Facebook'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Sign-Up Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    Get.toNamed("/signup");
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in with Google!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login failed: $e')),
      );
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
        print("Perform Google login");
        // Implement Google login logic here
        break;
    }
  }

/* Future<void> _loginWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
        await FirebaseAuth.instance.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in with Facebook!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facebook login canceled.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facebook login failed: $e')),
      );
    }
  }*/
}

enum LoginType {
  normal,
  facebook,
  google,
}
