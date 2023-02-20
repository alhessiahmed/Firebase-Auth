import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase_auth/firebase/fb_helper.dart';
import 'package:flutter_firebase_auth/models/process_response.dart';
import 'package:flutter_firebase_auth/widgets/show_snackbar_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FbAuthController with FbHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  String? smsVerificationId;

  static FbAuthController? _instance;
  FbAuthController._();

  factory FbAuthController() {
    return _instance ??= FbAuthController._();
  }

  Future<ProcessResponse?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleAuth.signIn();
      if (googleSignInAccount != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Once signed in, return the UserCredential
        await _firebaseAuth.signInWithCredential(credential);
        return ProcessResponse('Logged in successfully');
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return getAuthExceptionResponse(e);
    } catch (e) {
      return failureResponse;
    }
  }

// loginBehavior: LoginBehavior.dialogOnly
  Future<ProcessResponse?> signInWithFacebook() async {
    try {
      LoginResult loginResult = await _facebookAuth.login();
      if (loginResult.status.name == 'success') {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        // _firebaseAuth.currentUser!.linkWithCredential(facebookAuthCredential);
        return ProcessResponse('Logged in successfully');
      } else if (loginResult.status.name == 'failed') {
        return ProcessResponse(loginResult.message!, false);
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return getAuthExceptionResponse(e);
    } catch (e) {
      return failureResponse;
    }
  }

  Future<ProcessResponse> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
      return ProcessResponse('Logged in as a guest');
    } on FirebaseAuthException catch (e) {
      return getAuthExceptionResponse(e);
    } catch (e) {
      return failureResponse;
    }
  }

  Future<ProcessResponse> signInWithPhone(
      {required BuildContext context, required String phone}) async {
    // web
    // _firebaseAuth.signInWithPhoneNumber(phoneNumber)
    try {
      _firebaseAuth.verifyPhoneNumber(
        // Android only
        timeout: const Duration(seconds: 60),
        phoneNumber: phone,
        // forceResendingToken: ,
        verificationCompleted: (phoneAuthCredential) async {
          log('verificationCompleted');
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          showSnackbar(context: context, message: 'Logged in successfully');
        },
        verificationFailed: (e) {
          log('verificationFailed ${e.message}');
          showSnackbar(context: context, message: e.message!);
        },
        codeSent: (verificationId, forceResendingToken) {
          smsVerificationId = verificationId;
          log('codeSent');
          Navigator.pushNamed(context, '/otp');
        },
        codeAutoRetrievalTimeout: (verificationId) {
          log('codeAutoRetrievalTimeout');
        },
      );
      return ProcessResponse('Logged in successfully');
    } on FirebaseAuthException catch (e) {
      return getAuthExceptionResponse(e);
    } catch (e) {
      return failureResponse;
    }
  }

  Future<void> signOut() async {
    await _googleAuth.signOut();
    await _facebookAuth.logOut();
    await _firebaseAuth.signOut();
  }

  Future<ProcessResponse> verifySmscode({required String smsCode}) async {
    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: smsVerificationId!, smsCode: smsCode);
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      return ProcessResponse('Sms code verified successfully');
    } on FirebaseAuthException catch (e) {
      return getAuthExceptionResponse(e);
    } catch (e) {
      return failureResponse;
    }
  }

  bool get loggedIn => _firebaseAuth.currentUser != null;

  User? get currentUser => _firebaseAuth.currentUser;
}
