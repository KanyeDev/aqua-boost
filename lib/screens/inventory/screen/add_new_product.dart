
import 'dart:typed_data';

import 'package:aquaboost/core/hight_and_width.dart';
import 'package:aquaboost/utilities/toast.dart';
import 'package:aquaboost/widgets/inkwell_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {

  //TODO: Add categories, remove cost, quantity
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoriesPriceController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  Color saveButtonColor = const Color(0xffB6D69E);
  Color eraseButtonColor = const Color(0xff8F4646);

  bool isLoading = false;
  bool addedImage = false;

  Uint8List? image;

  final CollectionReference _rawGoods = FirebaseFirestore.instance.collection("raw goods");
  Reference imageRef = FirebaseStorage.instance.ref().child("images");

  //TODO: Integer value validator for cost and kg

  Future<void> _selectDate() async {
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
      _selectTime();
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        timeController.text = "${picked.hour}:${picked.minute}";
      });
    }
  }

  void pickImage() async{

    try{
      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
      setState(() {
        image = bytesFromPicker;
      });
      if(image != null){
        setState(() {
          addedImage = true;
        });
      }

    }catch(e){
      Utility().toastMessage(e.toString());
    }
  }

  Future<void> _submitData() async{

    setState(() {
      isLoading = true;
    });

    try{
      Reference referenceImageToUpload = imageRef.child("${nameController.text}.jpeg");
      await referenceImageToUpload.putData(image!);
      String url = await referenceImageToUpload.getDownloadURL();

      await _rawGoods.doc(nameController.text).set({
        "name": nameController.text,
        "categories": categoriesPriceController.text,
        "date": dateController.text,
        "time": timeController.text,
        "description": descriptionController.text,
        "imageUrl": url
      }).then((value) {
        Utility().toastMessage("Product Added Successfully");
        setState(() {
          isLoading = false;
          nameController.text = "";
          categoriesPriceController.text= "";
          dateController.text= "";
          timeController.text= "";
          descriptionController.text= "";
          addedImage = false;


        });
      });


    }catch(e){
      Utility().toastMessage(e.toString());
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    timeController.dispose();
    dateController.dispose();
    categoriesPriceController.dispose();
    descriptionController.dispose();
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
              "Add New Product",
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: nameController,
                                decoration: InputDecoration(
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    hintText: "Product name",
                                    fillColor: const Color(0xffD9D9D9)),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter product Name";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: categoriesPriceController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffD9D9D9),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "Product Category",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter product Cost";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
        
                      // Product Description
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Expanded(
                          child: SizedBox(
                            height: 180,
                            width: 350,
                            child: TextFormField(
                              minLines: 7,
                              maxLines: 10,
                              scrollPhysics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              keyboardType: TextInputType.multiline,
                              controller: descriptionController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffD9D9D9),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: "Product Description",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter product Description";
                                }
                                return null;
                              },
                            ),
                          ),
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
                                onTap: _selectDate,
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
                                onTap: _selectTime,
                              ),
                            ),
        
                            const SizedBox(
                              height: 50,
                            ),
        
                            Padding(
                              padding: const EdgeInsets.only(left: 23.0),
                              child: CustomInkWellButton(const Duration(milliseconds: 200), 10, Alignment.center, 33, 205,
                                  "Erase All", false, eraseButtonColor,Colors.white, () {
                                  isLoading = false;
                                  nameController.text = "";
                                  categoriesPriceController.text= "";
                                  dateController.text= "";
                                  timeController.text= "";
                                  descriptionController.text= "";
                                  addedImage = false;


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
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 23.0),
                              child: CustomInkWellButton(
                                  const Duration(milliseconds: 200), 10, Alignment.center, 33, 205,
                                  "Submit", isLoading, saveButtonColor,Colors.white,  () {
                                if (_formKey.currentState!.validate()) {
                                  if(image == null){
                                    Utility().toastMessage("Please Insert Image");
                                    return;
                                  }
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: pickImage,
                              child: Expanded(
                                child: Container(
                                  width: 350,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffD9D9D9)),
                                  child: addedImage? Image.memory(image!): const Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Click to insert image",
                                      ),
                                      Icon(Icons.image)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                             Positioned(right: 40, top: 10, child: InkWell(onTap: (){
                              setState(() {
                                addedImage = false;
                                image =null;
                              });
                            }, child: const Icon(Icons.delete_outline, size: 35,))),
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
