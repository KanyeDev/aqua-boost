//import 'package:aquaboost/screens/auth/register.dart';
import 'package:aquaboost/core/hight_and_width.dart';
import 'package:aquaboost/screens/main/main_screen.dart';
import 'package:aquaboost/utilities/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/inkwell_button.dart';
import '../../widgets/underlined_text_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  Color buttonColor = const Color(0xffB6D69E);

  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  void _login() {
    setState(() {
      isLoading = true;
    });
    _auth.signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text).then((
        value) {
      Utility().toastMessage("Login Successful");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>  MainScreen()));
    }).onError((error, stackTrace) {
      Utility().toastMessage("Invalid Credentials: contact admin");
      setState(() {
        isLoading = false;
      });
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
        .width < 1300 || (MediaQuery.of(context).size.height < 720)) {
      return const Center(
          child: (Text(
            "Please Login on Desktop",
            style: TextStyle(color: Color(0xff77C043)),
          )));
    } else {
      return Scaffold(
        body: SizedBox(height: mHeight(context), width: mWidth(context),
          child: SingleChildScrollView(
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
                       SizedBox(
                        height: mHeight(context)/8,
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
                                        "SIGN IN",
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
                                       Padding(
                                        padding: const EdgeInsets.only(left: 312.0),
                                        child: UnderlinedTextButton(
                                          text: 'FORGOT PASSWORD?', onTap: () {
                                          Utility().toastMessage("Contact Admin");
                                        },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomInkWellButton(const Duration(milliseconds: 200),9,Alignment.center,33,205,"SIGN IN",
                                              isLoading, buttonColor, Colors.white, () {
                                            if (_formKey.currentState!.validate()) {
                                              _login();
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
                                          UnderlinedTextButton(
                                            text: "Create Account", onTap: () {
                                            //Navigator.push(context, MaterialPageRoute(builder: (context)=> const Register()));
                                            Utility().toastMessage("Contact Admin");
                                          },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),

                          //Logo
                          Padding(
                            padding:  const EdgeInsets.only(right: 0.0),
                            child: SizedBox(
                                width: mWidth(context)/2,
                                height: mHeight(context)/2,
                                child: Image.asset("assets/images/logo.png")),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),

        ),
      );
    }
  }
}