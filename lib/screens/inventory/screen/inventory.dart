import 'package:aquaboost/core/hight_and_width.dart';
import 'package:aquaboost/screens/inventory/screen/add_new_product.dart';
import 'package:aquaboost/widgets/skeleton.dart';
import 'package:aquaboost/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widgets/flatWideButton.dart';
import '../../../widgets/search_and_sort.dart';
import '../../../widgets/topLineNav.dart';
import '../../../streamBuilders/build_stream_data.dart';
import '../widget/categoryShimerLoading.dart';
import '../widget/inventoryListShimmerLoading.dart';
import '../widget/table_entires.dart';
import 'add_product.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key //, required this.selectedIndex
      });

  // late  int selectedIndex;

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  bool isLoading = false;
  Color buttonColor = const Color(0xffB6D69E);
  Color removeButtonColor = const Color(0xffB6D69E);

  bool showInventory = true;
  bool showNewProducts = false;
  bool showNextNav = false;
  bool showProducts = false;
  String textForNav = "";

  final fireStore =
      FirebaseFirestore.instance.collection('raw goods').snapshots();

  final inventory =
      FirebaseFirestore.instance.collection('inventory').snapshots();

  final totalGoods =
      FirebaseFirestore.instance.collection('total goods').snapshots();

  double totalSum = 0;
  TextEditingController editController = TextEditingController();

  bool? firstExec;




  Future<String> getCollectionLength(String collectionName) async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(collectionName).get();
    return  querySnapshot.docs.length.toString();
  }

  StreamBuilder<QuerySnapshot<Object?>> SalesStreamData(Stream<QuerySnapshot<Object?>>? stream) {
    String roundToTwoDecimalPlaces(double value) => value.toStringAsFixed(2);

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Color(0xffB6D69E));
        }

        if (snapshot.hasError) {
          return const Text("Error");
        }


        if(firstExec == true){
          for(int i=0; i < snapshot.data!.docs.length; i++){
            if(double.parse(snapshot.data!.docs[i]['quantity']) <500 ){
              totalSum +=1;
            }
          }
        }

        firstExec = false;
        return Text(totalSum.toString(),
            style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold,));
      },
    );
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstExec = true;
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.only(left: 300.0, top: 90, right: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopLineNavigation(
                show: showNextNav,
                text: textForNav,
                onTap: () {
                  setState(() {
                    showNextNav = false;
                    showInventory = true;
                    showNewProducts = false;
                    showProducts = false;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Visibility(
                    visible: showNewProducts,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(child: AddNewProduct()),
                    ),
                  ),
                  //add product
                  Visibility(
                      visible: showInventory, child: inventoryWidget(context)),

                  Visibility(
                    visible: showProducts,
                    child: const Padding(
                      padding: EdgeInsets.only( top: 20),
                      child: Center(child: AddProduct()),
                    ),
                  ),
                  //inventory
                ],
              ),
              const Gap(40)
            ],
          )),
    );
  }

  SizedBox inventoryWidget(BuildContext context) {
    return SizedBox(
      width: 1156.7,
      height: 753.64,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Text("Inventory Summary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.82)),
            const Expanded(child: SizedBox()),
            wideFlatButton("Add New Product", Icons.add, () {
              setState(() {
                showNextNav = true;
                textForNav = "Add New Product";
                showInventory = false;
                showNewProducts = true;
                buttonColor = const Color(0xffB6D69E);
              });
            }, (value) {
              if (value == true) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    buttonColor = const Color(0xff749959);
                  });
                });
              } else {
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    buttonColor = const Color(0xffB6D69E);
                  });
                });
              }
              return null;
            }, buttonColor),
            const SizedBox(
              width: 30,
            ),
            //TODO: Cant allow the remove product, change to update product
            wideFlatButton("Add Product", Icons.add, () {
              setState(() {
                showNextNav = true;
                textForNav = "Add Product";
                showInventory = false;
                showProducts = true;
                removeButtonColor = const Color(0xffB6D69E);
              });
            }, (value) {
              if (value == true) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    removeButtonColor = const Color(0xff749959);
                  });
                });
              } else {
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    removeButtonColor = const Color(0xffB6D69E);
                  });
                });
              }
              return null;
            }, removeButtonColor),
          ]),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // product summary
              SizedBox(
                width: 416.38,
                height: 166.55,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0.8, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Gap(20),
                      Row(
                        children: [
                          const Gap(25),
                          SizedBox(
                              height: 37.4,
                              width: 37.4,
                              child: Image.asset("assets/images/products.png")),
                          const Gap(12),
                          const Text(
                            "Product Summary",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      const Gap(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "All Product",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const Gap(10),
                  FutureBuilder<String>(
                    // Pass your asynchronous function here
                    future: getCollectionLength("raw goods"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Display a loading indicator while waiting for the data
                        return const CircularProgressIndicator(color: Color(0xffB6D69E),);
                      } else if (snapshot.hasError) {
                        // Display an error message if an error occurred
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Display the data returned by the asynchronous function
                        return Text(snapshot.data ?? '',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold,),);
                      }
                    },
                  ),
                            ],
                          ),
                           Column(
                            children: [
                              const Text(
                                "In Store",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const Gap(10),
                              FutureBuilder<String>(
                                // Pass your asynchronous function here
                                future: getCollectionLength("total goods"),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    // Display a loading indicator while waiting for the data
                                    return const CircularProgressIndicator(color: Color(0xffB6D69E),);
                                  } else if (snapshot.hasError) {
                                    // Display an error message if an error occurred
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Display the data returned by the asynchronous function
                                    return Text(snapshot.data ?? '',
                                      style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold,),);
                                  }
                                },
                              ),

                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  height: 25,
                                  width: 85,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          width: 1.5,
                                          color: const Color(0xffFF5500))),
                                  child: const Center(
                                    child: Text(
                                      "Low-In-Stock",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              const Gap(10),
                              SalesStreamData(totalGoods),

                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const Gap(35),
              //Category
              Expanded(
                child: Container(
                  width: mWidth(context)/3.6 -14,
                  height: 166.55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0.8, 2), // changes position of shadow
                      ),
                    ],
                  ),

                  //All Products Categories
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      Row(
                        children: [
                          const Gap(25),
                          SizedBox(
                              height: 37.4,
                              width: 37.4,
                              child: Image.asset("assets/images/category.png")),
                          const Gap(12),
                          const Text(
                            "All Products",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      const Gap(15),
                      StreamBuilder<QuerySnapshot>(
                          stream: fireStore,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25, bottom: 20),
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          categoryShimmerLoading(),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                            width: 15,
                                          ),
                                      itemCount: 5),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return const Text("Error");
                            }

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            right: 30.0, bottom: 15),
                                        child: Container(
                                            height: 54.95,
                                            width: 133.24,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.49),
                                                border: Border.all(
                                                    width: 2,
                                                    color: primaryColor[
                                                        index % 4])),
                                            child: Center(
                                              child: Text(
                                                snapshot
                                                    .data!.docs[index]['name']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                      );
                                    }),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(35),
          SizedBox(
            width: 1155.03,
            height: mHeight(context)/2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0.8, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                     SearchAndSort(text: "Inventory Summary", onPressed: () {  }, onEditTap: (value) {
                       setState(() {}); // Trigger rebuild when search query changes
                     }, editController: editController,),
                    const Gap(10),
                    const Divider(
                      color: Colors.black87,
                    ),
                    const TableEntries(deliveryOrRemoved: 'Delivery',),
                    const Divider(
                      color: Colors.black87,
                    ),
                    BuildStreamData(inventory, editController)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}




