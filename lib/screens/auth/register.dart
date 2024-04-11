import 'package:aquaboost/screens/auth/login.dart';
import 'package:aquaboost/utilities/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/inkwell_button.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  Color buttonColor = const Color(0xffB6D69E);

  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  void _register() {
    setState(() {
      isLoading = true;
    });
    _auth.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text).then((
        value) {
      Utility().toastMessage("Sign Up Successful");
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Login()));
    }).onError((error, stackTrace) {
      Utility().toastMessage(error.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery
        .of(context)
        .size
        .width < 1000) {
      return const Center(
          child: (Text(
            "Please SignUp on Desktop",
            style: TextStyle(color: Color(0xff77C043)),
          )));
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Opacity(opacity: 0.2, child: Image.asset("assets/images/fishpond.png")),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0, left: 91.0),
                    child: SizedBox(
                        height: 68,
                        width: 188,
                        child: Image.asset("assets/images/abfulllogo.png")),
                  ),
                  const SizedBox(
                    height: 187,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Form
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: SizedBox(
                            height: 556,
                            width: 544,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 91.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Username",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFormField(
                                            keyboardType:
                                            TextInputType.emailAddress,
                                            controller: _emailController,
                                            decoration: const InputDecoration(
                                              hintText: "user@email.com",
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Enter Mail";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          const Text(
                                            "Password",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            obscureText: true,
                                            controller: _passwordController,
                                            decoration: const InputDecoration(
                                              hintText: "password",
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Enter Password";
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomInkWellButton(const Duration(milliseconds: 200),9,Alignment.center, 33,205, "SIGN UP",
                                          isLoading, buttonColor, Colors.white, () {
                                        if (_formKey.currentState!.validate()) {
                                          _register();

                                        }
                                      }, (value) {
                                        if (value == true) {
                                          setState(() {
                                            buttonColor =
                                            const Color(0xff749959);
                                          });
                                        } else {
                                          setState(() {
                                            buttonColor =
                                            const Color(0xffB6D69E);
                                          });
                                        }
                                        return null;
                                      }),
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ),

                      //Logo
                      Padding(
                        padding: const EdgeInsets.only(right: 80.0),
                        child: SizedBox(
                            width: 347,
                            height: 519,
                            child: Image.asset("assets/images/logo.png")),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}