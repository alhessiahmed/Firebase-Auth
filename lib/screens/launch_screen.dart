import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/firebase/fb_auth_controller.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacementNamed(
            FbAuthController().loggedIn ? '/home' : '/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/firebase.jpeg',
              height: 200,
            ),
            const SizedBox(height: 30),
            const Text(
              'Firebase',
              style: TextStyle(
                fontSize: 45,
                color: Colors.deepOrange,
              ),
            ),
            const Text(
              'Authentication',
              style: TextStyle(fontSize: 45),
            ),
          ],
        ),
      ),
    );
  }
}
