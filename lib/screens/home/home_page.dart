import 'package:aquaboost/screens/buy_now/screen/buy.dart';
import 'package:aquaboost/screens/main/main_screen.dart';
import 'package:aquaboost/widgets/inkwell_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onTap});
  final VoidCallback onTap;



  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  Color buttonColor = const Color(0xffB6D69E);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              CustomInkWellButton(const Duration(milliseconds: 250),
                  15,
                  Alignment.center,
                  119,
                  214,
                  "\n\nNew Sales",
                  isLoading,
                  buttonColor,
                  Colors.black,
                  () {
                setState(() {
                  MainScreen().setWidget(const BuyNow());
                });
                    widget.onTap();
                  },
                      (value) {
                    if (value == true) {
                      Future.delayed(const Duration(milliseconds: 100),(){
                        setState(() {
                          buttonColor =
                          const Color(0xff749959);
                        });
                      });
                    } else {
                      Future.delayed(const Duration(milliseconds: 100),(){
                        setState(() {
                          buttonColor =
                          const Color(0xffB6D69E);
                        });
                      });
                    }
                    return null;
                  }),
              const Positioned(right: 82, top: 25, child: Icon(Icons.add, size: 45,)),
            ]
          )
        ],
      ),
    );
  }
}
