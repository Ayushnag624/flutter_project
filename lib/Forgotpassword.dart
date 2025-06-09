import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
      try {
        await auth.sendPasswordResetEmail(email: emailController.text);
        setState(() {
          errorMessage = 'Password reset email sent!';
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message ?? 'An error occurred';
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { FocusScope.of(context).unfocus(); },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/background.png"),
                fit: BoxFit.cover,
              ), color: Colors.black
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                child: SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Instruction Text
                                Text(
                                  "Enter your email to reset your password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 20),

                                // Email TextField
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Email is required";
                                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                      return "Enter a valid email";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.black),
                                    labelText: "Email",
                                    fillColor: Colors.white,
                                    filled: true,
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Error Message Display
                                if (errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      errorMessage,
                                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                // Reset Password Button
                                ElevatedButton(
                                  onPressed: isLoading ? null : _resetPassword,
                                  child: isLoading
                                      ? CircularProgressIndicator(color: Colors.black)
                                      : Text(
                                    "Reset Password",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF272626)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  ),
                                ),
                                SizedBox(height: 10),

                                // Back to Login Button
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "Back to Login",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
