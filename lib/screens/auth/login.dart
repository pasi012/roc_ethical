import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:roc_ethical/screens/auth/login_success_screen.dart';
import '../../consts/firebase_const.dart';
import '../../services/global_methods.dart';
import '../../widgets/google_button.dart';
import 'forget_pass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();

      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginSuccessScreen(),
        ));
        print('Succefully logged in');
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //email
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        controller: _emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200], // Background color
                          labelText: 'Email', // Floating label text
                          labelStyle: const TextStyle(color: Colors.black), // Color of the floating label text
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners (optional)
                            borderSide: BorderSide.none, // Remove border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners when focused (optional)
                            borderSide: const BorderSide(color: Colors.blue), // Border color when focused
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //Password
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          _submitFormOnLogin();
                        },
                        controller: _passTextController,
                        focusNode: _passFocusNode,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Please enter a valid password';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200], // Background color
                          labelText: 'Password', // Floating label text
                          labelStyle: const TextStyle(color: Colors.black), // Color of the floating label text
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners (optional)
                            borderSide: BorderSide.none, // Remove border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners when focused (optional)
                            borderSide: const BorderSide(color: Colors.blue), // Border color when focused
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context, routeName: ForgetPasswordScreen.routeName);
                  },
                  child: const Text(
                    'Forget password?',
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.normal),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent), // No background color
                    elevation: MaterialStateProperty.all<double>(
                        0), // Remove shadow/elevation
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(
                          color: Colors.black, width: 2), // Blue border
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Rounded corners (optional)
                      ),
                    ),
                  ),
                  onPressed: () {
                    _submitFormOnLogin();
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "OR".toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: GoogleButton(),
            ),
          ],
        ),
      ),
    );
  }
}
