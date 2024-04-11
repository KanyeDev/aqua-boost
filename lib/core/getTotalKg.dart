
import 'package:cloud_firestore/cloud_firestore.dart';

Future<double> getTotalKg(String date, CollectionReference<Object?> collection) async {
  var docSnapShot = await collection.doc(date).get();
  if (docSnapShot.exists) {
    Map<String, dynamic>? data = docSnapShot.data() as Map<String, dynamic>?;

    double totalKg = double.parse(data!['total quantity'].toString());
    return totalKg;
  }

  return 0;
}

Future<double> getTotalCost(String date, CollectionReference<Object?> collection) async {
  var docSnapShot = await collection.doc(date).get();
  if (docSnapShot.exists) {
    Map<String, dynamic>? data = docSnapShot.data() as Map<String, dynamic>?;

    double totalKg = double.parse(data!['total cost'].toString());
    return totalKg;
  }

  return 0;
}

