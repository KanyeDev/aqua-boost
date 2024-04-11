import 'package:aquaboost/core/hight_and_width.dart';
import 'package:aquaboost/streamBuilders/build_stream_data.dart';
import 'package:aquaboost/widgets/search_and_sort.dart';

import '../../../core/getTotalKg.dart';
import '../../../streamBuilders/stream_total_used.dart';
import '../../../widgets/flatWideButton.dart';
import '../../inventory/widget/table_entires.dart';
import '../widgets/productionShimmerLoading.dart';
import 'package:aquaboost/widgets/inkwell_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utilities/toast.dart';
import '../widgets/shortTableEntires.dart';

class InHouse extends StatefulWidget {
  const InHouse({super.key});

  @override
  State<InHouse> createState() => _InHouseState();
}

class _InHouseState extends State<InHouse> {
  final fireStore =
  FirebaseFirestore.instance.collection('total goods').snapshots();
  CollectionReference ref =
  FirebaseFirestore.instance.collection('total goods');

  final CollectionReference usedProduce =
  FirebaseFirestore.instance.collection("used produce");

  final CollectionReference finishedProducts =
  FirebaseFirestore.instance.collection("finished products");

  final CollectionReference totalFinishedProducts =
  FirebaseFirestore.instance.collection("sellable products");

  final allFinishedProducts =
  FirebaseFirestore.instance.collection('finished products').snapshots();

  TextEditingController editController = TextEditingController();
  TextEditingController totalGoodsEditController = TextEditingController();

  Color saveButtonColor = const Color(0xffB6D69E);
  bool isLoading = false;
  Color buttonColor = const Color(0xffB6D69E);
  Color removeButtonColor = const Color(0xffB6D69E);

  bool showProduction = true;
  bool showSummary = false;

  final usedProducts =
  FirebaseFirestore.instance.collection('used produce').snapshots();


  final _formKey = GlobalKey<FormState>();

  TextEditingController actorController = TextEditingController();


  //get the current values in integers
  Future<List<double>> getCurrentItemData(String name) async {
    var docSnapshot = await ref.doc(name).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      List<double> cost = [
        double.parse(data!['cost'].toString()),
        double.parse(data!['quantity'].toString())
      ];
      return cost;
    }
    return [0, 0];
  }

  double calculateCost(double cost, double quantity) {
    double singleKgCost = cost / quantity;
    return singleKgCost;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: Column(
            children: [
              SizedBox(width: 806.7,
                height: 63.64,
                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const Expanded(child: SizedBox()),
                  wideFlatButton("Add For Production", Icons.add, () {
                    setState(() {
                      showSummary = false;
                      showProduction = true;
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
                  wideFlatButton("View Summary", Icons.add, () {
                    setState(() {
                      showProduction = false;
                      showSummary = true;
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
              ),
              Stack(
                children: [
                  Visibility(visible: showProduction, child: buildAddGoodsProduction()),
            Visibility(visible: showSummary,
              child: Column(
                children: [
                Container(
                height: mHeight(context)/3,
                width: 1156.7,
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
                ), child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    const Gap(10),
                    SearchAndSort(text: 'General Product Summary', onPressed: () {  }, onEditTap: (value) {setState(() {
      
                    });  }, editController: totalGoodsEditController,),
                    const Gap(10),
                    const Divider(
                      color: Colors.black87,
                    ),
                    const ShortTableEntries(),
                    const Divider(
                      color: Colors.black87,
                    ),
                    StreamForTotalUsed(allFinishedProducts, totalGoodsEditController)
                  ],),
                ),),
                  const Gap(20),
                  Container(
                  height: mHeight(context)/2,
                  width: 1156.7,
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
                  child:  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: [
                      const Gap(10),
                       SearchAndSort(text: 'Each Product Summary', onPressed: () {  },onEditTap: (value) {
                         setState(() {}); // Trigger rebuild when search query changes
                       }, editController: editController,),
                      const Gap(10),
                      const Divider(
                        color: Colors.black87,
                      ),
                      const TableEntries(deliveryOrRemoved: 'Removed',),
                      const Divider(
                        color: Colors.black87,
                      ),
                      BuildStreamData(usedProducts, editController)
                    ],),
                  )),
                ],
              ),
            )
                ],
              ),
              const Gap(40)
            ],
          ),
        ),
      ),
    );
  }

  Container buildAddGoodsProduction() {
    return Container(
              height: mHeight(context)/1.3,
              width: mWidth(context)/1.5,
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
              child: Column(
                children: [
                  const Gap(10),
                  const Text(
                    "Products for Manufacturing",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    color: Colors.black38,
                  ),
                  Form(
                    key: _formKey,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: fireStore,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Expanded(
                              child: ListView.builder(itemCount: 7, itemBuilder: (context, index){
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: productionShimmerLoading(68, 778.24),
                                );
                              }),
                            );
                          }

                          if (snapshot.hasError) return const Text("Error");

                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Name : ${snapshot.data!
                                                    .docs[index]['name']
                                                    .toString()}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                  "Quantity Available : ${snapshot
                                                      .data!
                                                      .docs[index]['quantity']
                                                      .toString()}"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 10.0),
                                          child: SizedBox(
                                            height: 90,
                                            width: 500,
                                            child:
                                            buildProductList(snapshot, index),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          );
                        }),
                  ),
                ],
              ));
  }

  Widget buildProductList(AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      int index) {
    TextEditingController editingController = TextEditingController();
    TextEditingController authorController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            validator: (value) {
            },
            controller: editingController,
            decoration: InputDecoration(filled: true, focusedBorder: const OutlineInputBorder(),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: snapshot.data!.docs[index]['quantity'].toString()),
          ),
        ),
        const Gap(20),
        Expanded(
          child: TextFormField(
            validator: (value) {
            },
            controller: authorController,
            decoration: InputDecoration(filled: true, focusedBorder: const OutlineInputBorder(),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Taken by who?"),
          ),
        ),
        const Gap(20),
        Expanded(
          child: CustomInkWellButton(
              const Duration(milliseconds: 200),
              10,
              Alignment.center,
              33,
              205,
              "Remove Product",
              isLoading,
              saveButtonColor,
              Colors.white, () async {
            // if (_formKey.currentState!.validate()) {
            //
            // }

            try {

              //to calculate the new cost after removing the current cost from the cost of the one removed
              //first we get the single cost of each quantity
              double singleCost = calculateCost(
                  double.parse(snapshot.data!.docs[index]['cost'].toString()),
                  double.parse(
                      snapshot.data!.docs[index]['quantity'].toString()));

              //then we add to the current quantity
              double costTotal =
                  singleCost * int.parse(editingController.text.toString());


              //then calculate the cost and start deducting and adding to where neccessary
              List<double> costAndQuantity = await getCurrentItemData(snapshot.data!.docs[index]['name']);
              double newCostForTotal = costAndQuantity[0] - costTotal;
              double newQuantityForTotal =
                  costAndQuantity[1] - double.parse(editingController.text);

              if ((newQuantityForTotal >= 0 ) && (authorController.text.isNotEmpty)) {
                String id = DateTime
                    .now()
                    .microsecondsSinceEpoch
                    .toString();
                ref.doc(snapshot.data!.docs[index]['name']).update({
                  'quantity': newQuantityForTotal.toString(),
                  'cost': newCostForTotal.toString()
                }).then((value) async {
                  usedProduce.doc(id).set({
                    "name": snapshot.data!.docs[index]['name'].toString(),
                    "quantity": editingController.text,
                    "actor": authorController.text,
                    "cost": costTotal.toString(),
                    "date": snapshot.data!.docs[index]['date'].toString(),
                    "time": snapshot.data!.docs[index]['time'].toString()
                  });

                  DateTime date = DateTime.now();
                  String currentDay = date.day.toString() +
                      date.month.toString() + date.year.toString();

                  String dateToStore = "${date.day}-${date.month}-${date.year}";

                  double totalKg = await getTotalKg(currentDay, finishedProducts);
                  double totalCost = await getTotalCost(currentDay, finishedProducts);
                  double totalForAll = await getTotalKg("all", totalFinishedProducts);

                  double inputQuantity = double.parse(editingController.text);

                  double allTotal = inputQuantity + totalForAll;

                  totalFinishedProducts.doc("all").update({
                    "total quantity": allTotal.toString(),
                  });

                  if (totalKg > 0) {

                    double total = inputQuantity + totalKg;
                    double newCost = totalCost+ costTotal;


                    finishedProducts.doc(currentDay).update({
                      "total quantity": total.toString(),
                      "date": dateToStore,
                      "total cost":newCost.toString()
                    });
                  } else {
                    finishedProducts.doc(currentDay).set({
                      "total quantity": editingController.text,
                      "date": dateToStore,
                      "total cost": costTotal.toString()
                    });
                  }

                  Utility().toastMessage("Removed Successfully");
                }).onError((error, stackTrace) {
                  editingController.clear();
                  Utility().toastMessage(error.toString());
                });
              } else {
                Utility().toastMessage(
                    "Fill All Details Appropriately");
              }
            } catch (e) {
              editingController.clear();
              Utility().toastMessage(e.toString());
            }
            //_submitData();
          }, (value) {}),
        ),
      ],
    );
  }
}

