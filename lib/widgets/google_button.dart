import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:roc_ethical/screens/auth/login_success_screen.dart';
import '../consts/firebase_const.dart';
import '../services/global_methods.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await authInstance.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set(
              {
                'id': authResult.user!.uid,
                'name': authResult.user!.displayName,
                'email': authResult.user!.email,
                'shipping-address': '',
                'userWish': [],
                'userCart': [],
                'createdAt': Timestamp.now(),
              },
            );
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginSuccessScreen(),
            ),
          );
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              subtitle: '${error.message}', context: context);
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {} 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: (){
          _googleSignIn(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/google.png", fit: BoxFit.fill, width: 30, height: 30,),
            const SizedBox(width: 10,),
            Text(
              "Continue with Google",
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
