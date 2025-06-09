import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:om_ornament/home.dart';
import 'package:om_ornament/login.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final databaseref = FirebaseDatabase.instance.ref('Users');

  TextEditingController namec = TextEditingController();
  TextEditingController numberc = TextEditingController();
  TextEditingController emailc = TextEditingController();
  TextEditingController passc = TextEditingController();
  TextEditingController addrec = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String errorMessage = '';
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Container(

            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/bgl.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                child: SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                       Card(
                         elevation: 5,
                        shadowColor: Colors.black,
                        child: Container(
                          width: 350,
                          decoration: BoxDecoration(

                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sign up",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 45,
                                      color: Color(0xFFD6B574),
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  textField("Firm Name", namec),
                                  SizedBox(height: 10),

                                  textField("Address", addrec),
                                  SizedBox(height: 10),

                                  textField("Contact", numberc, isPhone: true),
                                  SizedBox(height: 10),

                                  textField("Email", emailc, isEmail: true),
                                  SizedBox(height: 10),

                                  passwordField(),
                                  SizedBox(height: 20),

                                  if (errorMessage.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        errorMessage,
                                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                  if (_isLoading)
                                    CircularProgressIndicator(color: Color(0xFFD6B574)),

                                  if (!_isLoading)
                                    ElevatedButton(
                                      onPressed: _registerUser,
                                      child: Text(
                                        "Signup",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F250B)),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFD6B574),
                                      ),
                                    ),
                                  SizedBox(height: 6),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => Login()),
                                      );
                                    },
                                    child: Text(
                                      "Already have an account?",
                                      style: TextStyle(color: Color(0xFF4F250B)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => Home()),
                                      );
                                    },
                                    child: Text(
                                      "Login as Guest",
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

  Widget textField(String label, TextEditingController controller,
      {bool isPhone = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone
          ? TextInputType.phone
          : isEmail
          ? TextInputType.emailAddress
          : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        if (isPhone && (value.length < 10 || value.length > 15)) {
          return "Enter a valid phone number";
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email";
        }
        return null;
      },
      decoration: inputDecoration(label),
    );
  }

  Widget passwordField() {
    return TextFormField(
      controller: passc,
      obscureText: _obscurePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password is required";
        }
        if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
        if (!RegExp(r'(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])').hasMatch(value)) {
          return "Include an uppercase letter, a number, and a special character";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.black),
        labelText: "Password",
        fillColor: Colors.white,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color: Colors.black),
      labelText: label,
      fillColor: Colors.white,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      labelStyle: TextStyle(color: Colors.black),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      errorMessage = "";
    });

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailc.text.trim(),
        password: passc.text,
      );

      await databaseref.child(userCredential.user!.uid).set({
        'Firm Name': namec.text.trim(),
        'Address': addrec.text.trim(),
        'Contact': numberc.text.trim(),
        'Email': emailc.text.trim(),
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "An unknown error occurred";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
