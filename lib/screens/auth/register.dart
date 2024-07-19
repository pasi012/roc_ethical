import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roc_ethical/screens/auth/login.dart';
import '../../consts/firebase_const.dart';
import '../../fetch_screen.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _addressController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _conPassTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode();
  final _conPassFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  bool _obscureText = true;

  bool _isChecked = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    _fullNameFocusNode.dispose();
    _conPassFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        final User? user = authInstance.currentUser;
        final _uid = user!.uid;
        user.updateDisplayName(_fullNameController.text);
        user.reload();
        await FirebaseFirestore.instance.collection('users').doc(_uid).set(
          {
            'id': _uid,
            'name': _fullNameController.text,
            'email': _emailTextController.text.toLowerCase(),
            'shipping-address': _addressController.text,
            'userWish': [],
            'userCart': [],
            'createdAt': Timestamp.now(),
          },
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
        Fluttertoast.showToast(
          msg: "Succefully registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        print('Succefully registered');
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
    final theme = Utils(context).getTheme;
    Color color = Utils(context).color;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // User name
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "User Name*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: color),
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_fullNameFocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is missing";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200], // Background color
                            hintText: 'Enter Your Name', // Floating label text
                            hintStyle: const TextStyle(
                                color: Colors
                                    .grey), // Color of the floating label text
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Rounded corners (optional)
                              borderSide: BorderSide.none, // Remove border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Rounded corners when focused (optional)
                              borderSide: const BorderSide(
                                  color: Colors.blue), // Border color when focused
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // Address
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Address*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: color),
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_addressFocusNode),
                          keyboardType: TextInputType.streetAddress,
                          controller: _addressController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is missing";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200], // Background color
                            hintText: 'Enter Your Address', // Floating label text
                            hintStyle: const TextStyle(
                                color: Colors
                                    .grey), // Color of the floating label text
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Rounded corners (optional)
                              borderSide: BorderSide.none, // Remove border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Rounded corners when focused (optional)
                              borderSide: const BorderSide(
                                  color: Colors.blue), // Border color when focused
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // Email
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Email*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: color),
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is missing";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200], // Background color
                            hintText: 'Enter Your Email', // Floating label text
                            hintStyle: const TextStyle(
                                color: Colors
                                    .grey),// Color of the floating label text
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Rounded corners (optional)
                              borderSide: BorderSide.none, // Remove border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Rounded corners when focused (optional)
                              borderSide: const BorderSide(
                                  color: Colors.blue), // Border color when focused
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // Password
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Password*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: color),
                          ),
                        ),
                        TextFormField(
                          focusNode: _passFocusNode,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return "Please enter a valid password";
                            } else {
                              return null;
                            }
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200], // Background color
                            hintText: 'Enter Your Password', // Floating label text
                            hintStyle: const TextStyle(
                                color: Colors
                                    .grey), // Color of the floating label text
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Rounded corners (optional)
                              borderSide: BorderSide.none, // Remove border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Rounded corners when focused (optional)
                              borderSide: const BorderSide(
                                  color: Colors.blue), // Border color when focused
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // Confirm password
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Confirm Password*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: color),
                          ),
                        ),
                        TextFormField(
                          focusNode: _conPassFocusNode,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _conPassTextController,
                          validator: (value) {
                            if (value != _passTextController.text) {
                              return "Password not match";
                            } else {
                              return null;
                            }
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_conPassFocusNode),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200], // Background color
                            hintText: 'Confirm Your Password', // Floating label text
                            hintStyle: const TextStyle(
                                color: Colors
                                    .grey),// Color of the floating label text
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Rounded corners (optional)
                              borderSide: BorderSide.none, // Remove border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Rounded corners when focused (optional)
                              borderSide: const BorderSide(
                                  color: Colors.blue), // Border color when focused
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                        child: const Text(
                          'By creating an account you agree\nto our terms and conditions.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: (){
                        _isChecked ? _submitFormOnRegister() : Fluttertoast.showToast(
                          msg: "Please agree our terms and condition",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.white,
                          textColor: Colors.red,
                          fontSize: 16.0,
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,)
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

}
