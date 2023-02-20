import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/firebase/fb_auth_controller.dart';
import 'package:flutter_firebase_auth/widgets/show_snackbar_widget.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);
  // final String verificationId;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying Phone Number'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Column(
            children: [
              const Text('We have sent an sms with a code'),
              SizedBox(
                width: size.width * 0.4,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 4,
                  ),
                  maxLength: 8,
                  onChanged: (value) async {
                    if (value.length == 6) {
                      _performVerifySmscode(value);
                    }
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '- - - - - -',
                    hintStyle: TextStyle(
                      fontSize: 30,
                      letterSpacing: 2,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 30,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performVerifySmscode(String code) async {
    final response = await FbAuthController().verifySmscode(smsCode: code);
    showSnackbar(
      context: context,
      message: response.message,
      success: response.success,
    );
    if (!mounted) return;
    if (response.success) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }
}
