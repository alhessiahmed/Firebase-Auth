import 'dart:developer';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/firebase/fb_auth_controller.dart';
import 'package:flutter_firebase_auth/widgets/show_snackbar_widget.dart';
import 'package:flutter_firebase_auth/widgets/text_field_widget.dart';

import '../widgets/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogging = false;
  final _formKey = GlobalKey<FormState>();
  Country? country;
  int maxLength = 9;
  // String phone = '';
  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        showCountryPicker(
                          context: context,
                          // countryFilter: ['PS', 'EG'],
                          // exclude: ['PS', 'EG'],
                          favorite: ['PS', 'EG'],
                          showPhoneCode: true,
                          onSelect: ((value) {
                            setState(() {
                              country = value;
                              log(country!.displayName);
                              log(country!.flagEmoji);
                              log(country!.example);
                              maxLength = country!.example.length;
                            });
                          }),
                        );
                      },
                      child: const Text('Pick Country'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            '${country?.flagEmoji ?? '🇵🇸'}  +${country?.phoneCode ?? '970'}'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLength: maxLength,
                            cursorColor: Colors.purple,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              // isDense: true,
                              counterText: '',
                              fillColor: Colors.grey[300],
                              hintText: 'phone number',
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // TextFieldWidget(
                    //   controller: _phoneController,
                    //   label: 'Phone Number',
                    //   isPhoneNumber: true,
                    // ),
                    // const SizedBox(height: 14),
                    // TextFieldWidget(
                    //   controller: _passwordController,
                    //   label: 'Password',
                    //   isPassword: true,
                    // ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        if (_phoneController.text.trim().isNotEmpty &&
                            _phoneController.text.trim().length == maxLength) {
                          setState(() {
                            _isLogging = true;
                          });
                          await _performLoginWithPhone();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text('sign in'.toUpperCase()),
                    ),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text(
              //       'Don\'t have an account?',
              //       style: TextStyle(
              //         color: Colors.grey,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //     TextButton(
              //       onPressed: () {},
              //       child: const Text(
              //         'Sign Up',
              //         style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                children: const [
                  Expanded(
                    child: Divider(
                      indent: 50,
                      thickness: 2,
                      height: 60,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('OR'),
                  ),
                  Expanded(
                    child: Divider(
                      endIndent: 50,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    _isLogging = true;
                  });
                  await _performLoginWithFacebook();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                icon: Image.asset(
                  'images/facebook.png',
                  height: 20,
                ),
                label: const Text('Continue With Facebook'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    _isLogging = true;
                  });
                  await _performLoginWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3A79),
                ),
                icon: Image.asset(
                  'images/google.png',
                  height: 20,
                ),
                label: const Text('Continue With Google'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isLogging = true;
                  });
                  await _performLoginAnonymously();
                },
                child: const Text('sign in as aguest'),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isLogging,
          child: const LoadingWidget(),
        ),
      ],
    );
  }

  Future<void> _performLoginWithPhone() async {
    String phone = _phoneController.text.trim();
    final response = await FbAuthController().signInWithPhone(
        context: context, phone: '+${country?.phoneCode ?? '970'}$phone');
    setState(() {
      _isLogging = false;
    });
    showSnackbar(
      context: context,
      message: response.message,
      success: response.success,
    );
  }

  Future<void> _performLoginAnonymously() async {
    final response = await FbAuthController().signInAnonymously();
    if (!mounted) return;
    setState(() {
      _isLogging = false;
    });
    showSnackbar(
      context: context,
      message: response.message,
      success: response.success,
    );
    if (response.success) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _performLoginWithGoogle() async {
    final nav = Navigator.of(context);
    final response = await FbAuthController().signInWithGoogle();
    setState(() {
      _isLogging = false;
    });
    // if (!mounted) return;
    if (response != null) {
      showSnackbar(
        context: context,
        message: response.message,
        success: response.success,
      );
      if (response.success) {
        nav.pushReplacementNamed('/home');
      }
    }
  }

  Future<void> _performLoginWithFacebook() async {
    final response = await FbAuthController().signInWithFacebook();
    setState(() {
      _isLogging = false;
    });
    if (!mounted) return;
    if (response != null) {
      showSnackbar(
        context: context,
        message: response.message,
        success: response.success,
      );
      if (response.success) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }
}
