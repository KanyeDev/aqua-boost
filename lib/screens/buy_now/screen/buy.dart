import 'package:aquaboost/core/hight_and_width.dart';
import 'package:aquaboost/utilities/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

import '../../../core/getTotalKg.dart';
import '../../../widgets/inkwell_button.dart';
import '../widget/my_textField.dart';

class BuyNow extends StatefulWidget {
  const BuyNow({super.key});

  @override
  State<BuyNow> createState() => _BuyNowState();
}

class _BuyNowState extends State<BuyNow> {
  Color submitButtonColor = const Color(0xffB6D69E);
  Color checkoutButtonColor = const Color(0xffB6D69E);
  bool isLoading = false;
  bool isNewOrderVisible = true;
  bool previewVisible = false;
  bool purchaseVisible = false;
  bool showSuccessDone = false;
  bool showPrint =  false;
  final _formKey = GlobalKey<FormState>();
  Color buttonColor = const Color(0xffB6D69E);

  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController buyerController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final CollectionReference totalFinishedProducts =
  FirebaseFirestore.instance.collection("sellable products");

  final CollectionReference sales =
  FirebaseFirestore.instance.collection("sales");

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
      });
      selectTime();
    }
  }

  Future<void> selectTime() async {
    TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        timeController.text = "${picked.hour}:${picked.minute}";
      });
    }
  }

  void _submitData()async{
    try{
      double totalSellable = await getTotalKg("all", totalFinishedProducts);
      double currentQuantity = double.parse(quantityController.text);
      print("total sellable $totalSellable");
      if(currentQuantity <= totalSellable){
        //send the new data to database, the quantity, cost and rest
        String id = DateTime.now().microsecondsSinceEpoch.toString();
        sales.doc(id).set({
          "total quantity": quantityController.text,
          "total cost":priceController.text,
          "buyer name":buyerController.text,
          "date":dateController.text,
          "time": timeController.text

        });
        //remove them from the total sellable products
        String newTotalQuantity = (totalSellable - currentQuantity).toString();
        totalFinishedProducts.doc("all").update({
          "total quantity": newTotalQuantity
        });

        //display a good animation of checkout successful
        setState(() {
          showSuccessDone = true;
          showPrint = true;
        });


      }
      else{
        Utility().toastMessage("Low In Stock For Amount ($totalSellable max)");
      }
    }catch(e){
      Utility().toastMessage(e.toString());
    }
  }

  void printData(){

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Gap(150),
          Stack(
            children: [
              Visibility( visible: isNewOrderVisible,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 190.0),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                      isNewOrderVisible = false;
                                      previewVisible = true;
                                    });

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
                  ),
                ),
              ),
              Visibility(visible: previewVisible,
                child: Container(
                  height: mHeight(context)/1.5 + 70,
                  width: 523,
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(10),
                            const Center(
                                child: Text(
                              "Order Details",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            const Gap(20),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 43.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Product : ",
                                      style:
                                          TextStyle(color: Colors.black54, fontSize: 20)),
                                  Gap(30),
                                  Text("Fish Feeds",
                                      style: TextStyle(color: Colors.black, fontSize: 18))
                                ],
                              ),
                            ),
                            const Gap(10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 43.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Total(kg) : ",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 20)),
                                  const Gap(42),
                                  Expanded(
                                      child: MyTextFormFIeld(
                                    returnText: "Enter Quantity",
                                    controller: quantityController,
                                    hintText: "What is the Quantity?",
                                  ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 43.0),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Price(#) : ",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 20)),
                                  const Gap(50),
                                  Expanded(child: MyTextFormFIeld(
                                    returnText: "Enter Quantity",
                                    controller: priceController,
                                    hintText: "What is the Price?",
                                  ),),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 43.0),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Customer : ",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 20)),
                                  const Gap(35),
                                  Expanded(child: MyTextFormFIeld(
                                    returnText: "Enter Quantity",
                                    controller: buyerController,
                                    hintText: "What is the Buyers Name?",
                                  ),),
                                ],
                              ),
                            ),
                            const Gap(20),
                            //Date Picker
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 45.0, right: 60, bottom: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: dateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  filled: true,
                                  fillColor: const Color(0xffD9D9D9),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "Date",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Date";
                                  }
                                  return null;
                                },
                                onTap: selectDate,
                              ),
                            ),
                            //Time picker
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 45.0, right: 110, top: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: timeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.timer),
                                  filled: true,
                                  fillColor: const Color(0xffD9D9D9),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "Time",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Time";
                                  }
                                  return null;
                                },
                                onTap: selectTime,
                              ),
                            ),
                            const Gap(30),
                            CustomInkWellButton(
                                const Duration(milliseconds: 200),
                                10,
                                Alignment.center,
                                33,
                                205,
                                "Preview Order",
                                isLoading,
                                submitButtonColor,
                                Colors.white, () async {
                              if (_formKey.currentState!.validate()) {
                    
                                setState(() {
                                  previewVisible = false;
                                  purchaseVisible = true;
                                });
                    
                              }
                    
                    
                            }, (value) {
                              if (value == true) {
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  setState(() {
                                    submitButtonColor = const Color(0xff749959);
                                  });
                                });
                              } else {
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  setState(() {
                                    submitButtonColor = const Color(0xffB6D69E);
                                  });
                                });
                              }
                              return null;
                            }),
                            const Gap(10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(visible: purchaseVisible,
                child: Container(
                  height: mHeight(context)/1.5 +70,
                  width: 523,
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
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Gap(20),
                          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Gap(110),
                              Text(
                                "Preview Order",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Gap(180)
                            ],
                          ),
                  
                           const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            SizedBox(height: 90, width: 90, child: Image(image: AssetImage("assets/images/logo.png"))),
                            Image(image: AssetImage("assets/images/aquaboost.png")),
                          ],),
                          const Gap(30),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 43.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Gap(60),
                                Text("Product : ",
                                    style:
                                    TextStyle(color: Colors.black54, fontSize: 20)),
                                Gap(120),
                                Text("Fish Feeds",
                                    style: TextStyle(color: Colors.black, fontSize: 18))
                              ],
                            ),
                          ),
                          const Gap(20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 43.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Gap(60),
                                const Text("Total(kg) : ",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20)),
                                const Gap(110),
                                Text(quantityController.text,style: const TextStyle(color: Colors.black, fontSize: 18) ),
                              ],
                            ),
                          ),
                          const Gap(20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 43.0),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Gap(60),
                                const Text("Price(#) : ",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20)),
                                const Gap(119),
                                Text(priceController.text,style: const TextStyle(color: Colors.black, fontSize: 18) ),
                              ],
                            ),
                          ),
                          const Gap(20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 43.0),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Gap(60),
                                const Text("Customer : ",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20)),
                                const Gap(104),
                                Text(buyerController.text,style: const TextStyle(color: Colors.black, fontSize: 18) ),
                              ],
                            ),
                          ),
                          const Gap(20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 43.0),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Gap(60),
                                const Text("Date : ",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20)),
                                const Gap(150),
                                Text(dateController.text,style: const TextStyle(color: Colors.black, fontSize: 18) ),
                              ],
                            ),
                          ),
                          const Gap(20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 43.0),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Gap(60),
                                const Text("Time : ",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20)),
                                const Gap(148),
                                Text(timeController.text,style: const TextStyle(color: Colors.black, fontSize: 18) ),
                              ],
                            ),
                          ),
                          const Gap(45),
                          showPrint? CustomInkWellButton(
                              const Duration(milliseconds: 200),
                              10,
                              Alignment.center,
                              33,
                              205,
                              "Print Receipt",
                              isLoading,
                              checkoutButtonColor,
                              Colors.white, () async {
                            printData();
                            setState(() {
                              previewVisible = true;
                              purchaseVisible = false;
                              showSuccessDone = false;
                            });
                          }, (value) {
                            if (value == true) {
                              Future.delayed(const Duration(milliseconds: 100), () {
                                setState(() {
                                  checkoutButtonColor = const Color(0xff749959);
                                });
                              });
                            } else {
                              Future.delayed(const Duration(milliseconds: 100), () {
                                setState(() {
                                  checkoutButtonColor = const Color(0xffB6D69E);
                                });
                              });
                            }
                            return null;
                          }): CustomInkWellButton(
                              const Duration(milliseconds: 200),
                              10,
                              Alignment.center,
                              33,
                              205,
                              "Checkout",
                              isLoading,
                              checkoutButtonColor,
                              Colors.white, () async {
                            _submitData();
                          }, (value) {
                            if (value == true) {
                              Future.delayed(const Duration(milliseconds: 100), () {
                                setState(() {
                                  checkoutButtonColor = const Color(0xff749959);
                                });
                              });
                            } else {
                              Future.delayed(const Duration(milliseconds: 100), () {
                                setState(() {
                                  checkoutButtonColor = const Color(0xffB6D69E);
                                });
                              });
                            }
                            return null;
                          }),
                          const Gap(10),
                        ],
                      ),
                      Visibility(visible: showSuccessDone, child: Lottie.asset('assets/lottie/done.json', width: 500, height: 500)),
                      Positioned(left: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10),
                          child: IconButton(onPressed: (){setState(() {
                            previewVisible = true;
                            purchaseVisible = false;
                            showSuccessDone = false;
                          });}, icon: const Icon(Icons.arrow_back_ios)),
                        ),
                      ),
                    ],
                  ),
                ),),
              ),
            ],
          )
        ],
      ),
    );
  }
}

