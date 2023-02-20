import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/firebase/fb_auth_controller.dart';
import 'package:flutter_firebase_auth/widgets/loading_widget.dart';
import 'package:flutter_firebase_auth/widgets/show_snackbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLogging = false;
  final user = FbAuthController().currentUser!;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('User Details'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Image.network(
                    user.photoURL ??
                        'https://www.dsscotland.org.uk/wp-content/uploads/2015/05/profile.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  user.displayName?.isNotEmpty ?? false
                      ? user.displayName!
                      : 'Anonymous User',
                ),
                const SizedBox(height: 10),
                Text(
                  user.phoneNumber?.isNotEmpty ?? false
                      ? user.phoneNumber!
                      : 'No Phone Linked',
                ),
                const SizedBox(height: 10),
                Text(
                  user.email?.isNotEmpty ?? false
                      ? user.email!
                      : 'No Email Linked',
                ),
                const SizedBox(height: 10),
                Text(
                    'You have signed in using your ${user.isAnonymous ? 'Anonymous Provider' : user.providerData.first.providerId}'),
                const SizedBox(height: 30),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLogging = true;
                      });
                      await _performSignOut();
                    },
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isLogging,
          child: const LoadingWidget(),
        ),
      ],
    );
  }

  Future<void> _performSignOut() async {
    // if (user.isAnonymous) {
    //   await user.delete();
    // }
    await FbAuthController().signOut();
    setState(() {
      _isLogging = false;
    });

    showSnackbar(context: context, message: 'Signed Out Successfully');
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
