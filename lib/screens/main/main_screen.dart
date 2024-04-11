import 'package:aquaboost/core/hight_and_width.dart';
import 'package:aquaboost/screens/buy_now/screen/buy.dart';
import 'package:aquaboost/screens/in_house/screen/in_house.dart';
import 'package:aquaboost/screens/inventory/screen/add_new_product.dart';
import 'package:aquaboost/screens/inventory/screen/inventory.dart';
import 'package:aquaboost/screens/settings/settings.dart';
import 'package:aquaboost/widgets/inkwell_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/sideBarMenuButtons.dart';
import '../home/home_page.dart';
import '../sales/screen/sales.dart';

class MainScreen extends StatefulWidget {
   MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
  Widget widgetToRender = const BuyNow();

  //function to set the widget to render to the current widget
  void setWidget(Widget widget){
   widgetToRender = widget;
  }

}

class _MainScreenState extends State<MainScreen> {
  bool isExtended = false;
  int extendDuration = 200;
  double width = 67.0;
  bool isVisible = false;
  Color homeButtonColor = Colors.white;
  Color inHouseButtonColor = Colors.white;
  Color buyButtonColor = Colors.white;
  Color inventoryButtonColor = Colors.white;
  Color salesButtonColor = Colors.white;
  Color settingsButtonColor = Colors.white;
  bool isLoading = false;


  Widget renderWidget(){
    Widget? render;
    setState(() {
      render = widget.widgetToRender;
    });
    return render!;
  }


  @override
  Widget build(BuildContext context) {
    if ((MediaQuery.of(context).size.width < 1300) || (MediaQuery.of(context).size.height < 720)) {
      return const Center(
          child: (Text(
            "Please Login on Desktop",
            style: TextStyle(color: Color(0xff77C043)),
          )));
    } else {
      return Scaffold(
      backgroundColor: Colors.black12,
      body: Stack(
        children: [
          Align(alignment: Alignment.bottomRight, child: SizedBox(width: mWidth(context)/4, height: mHeight(context)/2.2, child: Image.asset("assets/images/curvedlogo.png", alignment: Alignment.bottomRight,))),

          renderWidget(),

          //side base for selection
          sideBar(),

          //Search bar and the admin bar
          Padding(
            padding:  EdgeInsets.only(top: 25.0, left: mWidth(context)/6),
            child: Container(
              height: 56,
              width: mWidth(context)/1.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 50,
                    width: mWidth(context)/3,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                1, 2), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search...",
                              hintStyle: TextStyle(color: Colors.grey)),
                        )),
                        Icon(
                          CupertinoIcons.search,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                   SizedBox(
                    width: mWidth(context)/6,
                  ),
                  const Icon(CupertinoIcons.cart_fill),
                  const SizedBox(
                    width: 30,
                  ),
                  const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Aqua Boost",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "Admin",
                        style: TextStyle(fontWeight: FontWeight.w100),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
  }

  Padding sideBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0),
      child: InkWell(
        onHover: (value) {
          if (value == true) {
            setState(() {
              width = 258.0;
              isExtended = true;
              Future.delayed(const Duration(milliseconds: 220), () {
                setState(() {
                  isVisible = true;
                });
              });
            });
          } else {
            setState(() {
              isExtended = false;
              width = 67.0;
              isVisible = false;
            });
          }
        },
        onTap: () {},
        child: buildSideBar(),
      ),
    );
  }

  AnimatedContainer buildSideBar() {
    return AnimatedContainer(
        duration: Duration(milliseconds: extendDuration),
        curve: Curves.linearToEaseOut,
        height: 290,
        width: width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                    width: 20,
                    height: 31,
                    child: Image.asset("assets/images/logo.png")),
                isExtended
                    ? Visibility(
                        visible: isVisible,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: SizedBox(
                              width: width / 3,
                              height: 28,
                              child: Image.asset("assets/images/aquaboost.png")),
                        ))
                    : const SizedBox()
              ],
            ),

            // ///HOME
            // sideBarMenuButtons(isExtended,"Home", isVisible, Icons.home, () {
            //   setState(() {
            //     widget.setWidget( HomePage(onTap: () {
            //       setState(() {
            //           widget.setWidget(const BuyNow());
            //           renderWidget();
            //         });
            //
            //
            //       },));
            //   });
            // }, (value) {
            //   if (value == true) {
            //     setState(() {
            //       homeButtonColor = const Color(0xff989898);
            //     });
            //   } else {
            //     setState(() {
            //       homeButtonColor = const Color(0xffffffff);
            //     });
            //   }
            //   return null;
            // }, homeButtonColor), //home

            ///BUY NOW
            sideBarMenuButtons(isExtended,"Buy now", isVisible, Icons.home, () {
              setState(() {
                widget.setWidget(const BuyNow());
              });
            }, (value) {
              if (value == true) {
                setState(() {
                  buyButtonColor = const Color(0xff989898);
                });
              } else {
                setState(() {
                  buyButtonColor = const Color(0xffffffff);
                });
              }
              return null;
            }, buyButtonColor), //buy now


            ///IN HOUSE
            sideBarMenuButtons(isExtended,"In House", isVisible, Icons.store, () {
              setState(() {
                widget.setWidget(const InHouse());
              });
            }, (value) {
              if (value == true) {
                setState(() {
                  inHouseButtonColor = const Color(0xff989898);
                });
              } else {
                setState(() {
                  inHouseButtonColor = const Color(0xffffffff);
                });
              }
              return null;
            }, inHouseButtonColor), //in house

            ///INVENTORY
            sideBarMenuButtons(isExtended,"Inventory", isVisible, Icons.inventory, () {
              setState(() {
                widget.setWidget(const Inventory());
              });
            }, (value) {
              if (value == true) {
                setState(() {
                  inventoryButtonColor = const Color(0xff989898);
                });
              } else {
                setState(() {
                  inventoryButtonColor = const Color(0xffffffff);
                });
              }
              return null;
            }, inventoryButtonColor), //inventory

            ///SALES
            sideBarMenuButtons(isExtended,"Sales", isVisible, Icons.receipt_long, () {
              setState(() {
                widget.setWidget( Sales());
              });
            }, (value) {
              if (value == true) {
                setState(() {
                  salesButtonColor = const Color(0xff989898);
                });
              } else {
                setState(() {
                  salesButtonColor = const Color(0xffffffff);
                });
              }
              return null;
            }, salesButtonColor), //sales

            ///SETTINGS
            sideBarMenuButtons(isExtended, "Settings", isVisible, Icons.settings, () {
              setState(() {
                widget.setWidget(const Settings());
              });
            }, (value) {
              if (value == true) {
                setState(() {
                  settingsButtonColor = const Color(0xff989898);
                });
              } else {
                setState(() {
                  settingsButtonColor = const Color(0xffffffff);
                });
              }
              return null;
            }, settingsButtonColor) //settings
          ],
        ),
      );
  }


}

