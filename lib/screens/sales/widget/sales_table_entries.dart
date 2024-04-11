import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SalesTableEntries extends StatelessWidget {
  const SalesTableEntries({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "  Buyer Name",
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 18),
        ),
        Gap(2),
        Text(
          "   Cost",
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 18),
        ),
        Gap(20),
        Text(
          "      Quantity",
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 18),
        ),
       Gap(0.5),
        Text(
          "Date & Time",
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 18),
        ),
        Gap(40)
      ],
    );
  }
}