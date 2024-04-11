

import 'package:aquaboost/screens/inventory/model/product_model.dart';
import 'package:aquaboost/utilities/toast.dart';
import 'package:aquaboost/widgets/inkwell_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/hight_and_width.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

//TODO: Integer value validator for cost and kg

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();//Todo: show the name and make it not editable
  final costPriceController = TextEditingController();
  final personNameController = TextEditingController();
  final quantityController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();


  Color saveButtonColor = const Color(0xffB6D69E);
  Color eraseButtonColor = const Color(0xff8F4646);

  bool isLoading = false;
  String currentItem = "0";

  final CollectionReference inventory = FirebaseFirestore.instance.collection("inventory");
  final CollectionReference totalGoods = FirebaseFirestore.instance.collection("total goods");
  final fireStore = FirebaseFirestore.instance.collection('raw goods').snapshots();


  //TODO: Integer value validator for cost and kg

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


  Future<List<int>> getCurrentItemData(String name) async{
    var docSnapshot = await totalGoods.doc(name).get();
    if(docSnapshot.exists){
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      var value = data?['name'];
      print("the current price of the $name total cost is ${data?['cost']}");

      List<int> cost = [int.parse(data?['cost']), int.parse(data?['quantity'])];
      return cost;

    }
    return [0,0];
  }


  Future<void> _addTotal()async{

    List<int> data  = await getCurrentItemData(nameController.text);
    int cost = data[0];
    int quantity = data[1];
    int currentCost = int.parse(costPriceController.text);
    int currentQuantity = int.parse(quantityController.text);

    int totalCost = cost+ currentCost;

    int totalQuantity = quantity+ currentQuantity;

    print("\ntotal cost = ${totalCost.toString()}");

    try{
      Map<dynamic, dynamic> mapData = {
        "name": nameController.text,
        "quantity": totalQuantity.toString(),
        "cost": totalCost.toString(),
        "date": dateController.text,
        "time": timeController.text
      };

      TotalProductQuantityModel model = TotalProductQuantityModel.fromMap(mapData);
      await totalGoods.doc(nameController.text).set(model.toMap()).then((value) {
        Utility().toastMessage("Total Products Updated Successfully");
        setState(() {
          currentItem = "0";
          isLoading = false;
          nameController.text = "";
          costPriceController.text= "";
          quantityController.text= "";
          dateController.text= "";
          personNameController.text= "";
          timeController.text= "";

        });
      });
    }catch(e){
      Utility().toastMessage(e.toString());

    }
  }


  Future<void> _submitData() async{
    setState(() {
      isLoading = true;
    });
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    try{
      await inventory.doc(id).set({
        "name": nameController.text,
        "actor": personNameController.text,
        "cost": costPriceController.text,
        "quantity": quantityController.text,
        "date": dateController.text,
        "time": timeController.text
      }).then((value) {
        _addTotal();
        Utility().toastMessage("Inventory Updated Successfully");
      });
    }catch(e){
      Utility().toastMessage(e.toString());
    }

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    timeController.dispose();
    dateController.dispose();
    costPriceController.dispose();
    quantityController.dispose();
    personNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: mHeight(context)/1.7 +120,
      width: mWidth(context)/2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(1, 2), // changes position of shadow
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Product Details",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            //Product name
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                height: 55, width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(color:const Color(0xffD9D9D9), borderRadius: BorderRadius.circular(10) ),
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: fireStore,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasError) {
                                        return const Text("Error");
                                      }

                                      List<DropdownMenuItem> productNames = [];
                                      productNames.add(const DropdownMenuItem(value: '0',child: Text("Select Product To Update",style: TextStyle(color: Colors.black54),)));
                                      final names = snapshot.data!.docs.reversed.toList();
                                      for(var name in names!){
                                        productNames.add(DropdownMenuItem(value: name.id,child: Text(name["name"])));
                                      }

                                      return DropdownButton( underline: const SizedBox(),value: currentItem,items: productNames, onChanged: (value){
                                        setState(() {
                                          currentItem = value;
                                          nameController.text = value;
                                        });
                                        //print(value);// send this item to the database the moment the inventory is beign stored
                                      });
                                    }),
                              ),
                            ),
                            

                            //Product cost
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: costPriceController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffD9D9D9),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "Product Cost(#)",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter product Cost";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //product quantity
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: quantityController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffD9D9D9),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "Product Quantity(kg)",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter product Quantity";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //product actor
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: personNameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffD9D9D9),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "Who delivered the product?",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Actor Name";
                                  }
                                  return null;
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Date Picker
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 60, bottom: 10),
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
                              const EdgeInsets.only(left: 20.0, right: 110, top: 10),
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



                            const SizedBox(
                              height: 40,
                            ),

                            Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 23.0),
                                  child: CustomInkWellButton(const Duration(milliseconds: 200), 10, Alignment.center, 33, 205,
                                    "Erase All", false, eraseButtonColor,Colors.white, () {
                                      currentItem = "0";
                                      isLoading = false;
                                      nameController.text = "";
                                      costPriceController.text= "";
                                      quantityController.text= "";
                                      dateController.text= "";
                                      personNameController.text= "";
                                      timeController.text= "";

                                    }, (value) {
                                      if (value == true) {
                                        Future.delayed(
                                            const Duration(milliseconds: 100), () {
                                          setState(() {
                                            eraseButtonColor = const Color(0xffBF1616);
                                          });
                                        });
                                      } else {
                                        Future.delayed(
                                            const Duration(milliseconds: 100), () {
                                          setState(() {
                                            eraseButtonColor = const Color(0xff8C1212);
                                          });
                                        });
                                      }
                                      return null;
                                    }, ),
                                ),
                                const Gap(40),
                                Padding(
                                  padding: const EdgeInsets.only(left: 23.0),
                                  child: CustomInkWellButton(
                                      const Duration(milliseconds: 200), 10, Alignment.center, 33, 205,
                                      "Submit", isLoading, saveButtonColor,Colors.white,  () {
                                    if (_formKey.currentState!.validate()) {
                                      _submitData();
                                    }
                                  }, (value) {
                                    if (value == true) {
                                      Future.delayed(
                                          const Duration(milliseconds: 100), () {
                                        setState(() {
                                          saveButtonColor = const Color(0xff749959);
                                        });
                                      });
                                    } else {
                                      Future.delayed(
                                          const Duration(milliseconds: 100), () {
                                        setState(() {
                                          saveButtonColor = const Color(0xffB6D69E);
                                        });
                                      });
                                    }
                                    return null;
                                  }),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
