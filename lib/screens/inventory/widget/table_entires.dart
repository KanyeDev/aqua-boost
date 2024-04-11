import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TableEntries extends StatelessWidget {
  const TableEntries({
    super.key, required this.deliveryOrRemoved,
  });

  final String deliveryOrRemoved;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width:170,
          child: Text(
            "Product Name",
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),

        const SizedBox(width:150,
          child: Text(
            "Cost(#)",
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),

        const SizedBox(width:120,
          child: Text(
            "Quantity",
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),

        // const Text(
        //   "TIS(kg)",
        //   style: TextStyle(
        //       fontWeight: FontWeight.w300, fontSize: 18),
        // ),const Gap(20),
        // const Text(
        //   "TIS(#)",
        //   style: TextStyle(
        //       fontWeight: FontWeight.w300, fontSize: 18),
        // ),


         SizedBox(width:120,
           child: Text(
            deliveryOrRemoved,
            style: const TextStyle(
                fontWeight: FontWeight.w300, fontSize: 18),
                   ),
         ),

        const SizedBox(width:200,
          child: Text(
            "Date & Time",
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),
      ],
    );
  }
}