import 'package:aquaboost/core/hight_and_width.dart';
import 'package:aquaboost/screens/auth/login.dart';
import 'package:aquaboost/utilities/pageRoutes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500), (){
      Navigator.push(context, FadeRoute(page:  const Login()));
    }) ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(height: mHeight(context), width: mWidth(context), decoration: const BoxDecoration(color: Colors.black),
      child: const Center(
          child: Column(
            children: [
              SizedBox(height: 300,),
              SizedBox(width: 203, height: 303, child: Image(image: AssetImage("assets/images/logo.png"))),
              SizedBox(height: 50,),
              SizedBox(width: 249, height: 7, child: LinearProgressIndicator(backgroundColor: Color(0xff1FBCEE), color: Color(0xff77C043),))
            ],
          ),
        ));



  }
}
