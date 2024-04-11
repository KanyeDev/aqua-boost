import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ShortTableEntries extends StatelessWidget {
  const ShortTableEntries({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width:190,
          child: Text(
            "Total KG",
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),
        SizedBox(width:220,
          child: Text(
            "Total Cost",
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),
        SizedBox(width:150,
          child: Text(
            "Date",
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),
      ],
    );
  }
}