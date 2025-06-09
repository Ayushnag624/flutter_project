import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:om_ornament/Forgotpassword.dart';
import 'package:om_ornament/home.dart';
import 'package:om_ornament/signup.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailc = TextEditingController();
  TextEditingController passc = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if user is already logged in
  void _checkLoginStatus() async {
    User? user = auth.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/bgl.jpg"),
              fit: BoxFit.cover,
            ),

          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Card(
                    elevation: 5,

                    shadowColor: Colors.black,

                    child: Container(

                      height: 450,
                      width: 350,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),

                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    color: Color(0xFFD6B574),
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Email Field
                                buildTextField("Email", emailc, isEmail: true),
                                SizedBox(height: 15),

                                // Password Field
                                buildPasswordField(),
                                SizedBox(height: 15),

                                // Error Message Display
                                if (errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      errorMessage,
                                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                // Login Button
                                _isLoading
                                    ? CircularProgressIndicator(color:Color(0xFFD6B574))
                                    : ElevatedButton(
                                  onPressed: _loginUser,
                                  child: Text(
                                    "Login",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F250B)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFD6B574),
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                  ),
                                ),
                                SizedBox(height: 10),

                                // Forgot Password Button
                                TextButton(
                                  onPressed: () {
                                    Get.to (() => ForgotPasswordPage()
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Color(0xFF4F250B)),
                                  ),
                                ),

                                // Navigate to Signup Page
                                TextButton(
                                  onPressed: () {
                                    Get.to (() =>  Signup()
                                    );
                                  },
                                  child: Text(
                                    "Don't have an account? Sign Up",
                                    style: TextStyle(color: Color(0xFF4F250B)),
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

  // Login Function
  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        errorMessage = "";
      });

      try {
        await auth.signInWithEmailAndPassword(
          email: emailc.text.trim(),
          password: passc.text.trim(),
        );

        // Store email in SharedPreferences for future use
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', emailc.text.trim());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = _getErrorMessage(e.code);
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Error Message Handling
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Try again.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Generic TextField Widget
  Widget buildTextField(String label, TextEditingController controller, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.black),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white,
        filled: true,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Password Field Widget
  Widget buildPasswordField() {
    return TextFormField(
      controller: passc,
      obscureText: _obscurePassword,
      validator: (value) => value!.isEmpty ? "Password is required" : null,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.black),
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white,
        filled: true,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }
}
