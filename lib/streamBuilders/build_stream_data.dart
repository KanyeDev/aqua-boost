
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/inventory/widget/inventoryListShimmerLoading.dart';


StreamBuilder<QuerySnapshot<Object?>> BuildStreamData(Stream<QuerySnapshot<Object?>>? stream, TextEditingController searchController) {
  String roundToTwoDecimalPlaces(double value) => value.toStringAsFixed(2);

  return StreamBuilder<QuerySnapshot>(
    stream: stream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25, top: 6),
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => inventoryListShimmer(30.95),
              separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
              itemCount: 8,
            ),
          ),
        );
      }

      if (snapshot.hasError) {
        return const Text("Error");
      }

      // Filter documents based on search query
      List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
        String actorName = doc['actor'].toString().toLowerCase();
        String name = doc['name'].toString().toLowerCase();
        String date = doc['date'].toString().toLowerCase();
        String quantity = doc['quantity'].toString().toLowerCase();
        String searchQuery = searchController.text.toLowerCase();
        return name.contains(searchQuery) || actorName.contains(searchQuery) || date.contains(searchQuery) || quantity.contains(searchQuery);
      }).toList();

      // Sort the filtered documents by timestamp in descending order
      filteredDocs.sort((a, b) => (b['date']).compareTo(a['date']));

      return Expanded(
        child: ListView.builder(
          reverse: false, // Set reverse to true to display the most recent item first
          itemCount: filteredDocs.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 170,
                    child: Text(
                      filteredDocs[index]['name'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      roundToTwoDecimalPlaces(double.parse(filteredDocs[index]['cost'])),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(
                      roundToTwoDecimalPlaces(double.parse(filteredDocs[index]['quantity'])),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(
                      filteredDocs[index]['actor'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      "${filteredDocs[index]['date']} : ${filteredDocs[index]['time']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

