import 'package:flutter/material.dart';
import 'package:roc_ethical/screens/auth/register.dart';

import 'login.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({super.key});

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20,),
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            height: 200,
            width: 200,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // No background color
                  elevation: MaterialStateProperty.all<double>(0), // Remove shadow/elevation
                  side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(color: Colors.black, width: 2), // Blue border
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners (optional)
                    ),
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const LoginScreen(),
                  ));
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: SizedBox(
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const RegisterScreen(),
                  ));
                },
                child: const Text(
                    "Sign Up",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50,)
        ],
      ),
    );
  }
}
