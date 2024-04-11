import 'package:flutter/material.dart';

class TopLineNavigation extends StatelessWidget {
  const TopLineNavigation({
    super.key, required this.show, required this.text, required this.onTap,
  });
  final bool show;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const Divider(
          color: Colors.black,
          thickness: 0.8,
        ),
        Row(
          children: [
            const Icon(Icons.home_outlined, size: 22.72,),
            const Text("  /  "),
            InkWell(onTap: onTap, child: const Text("  Inventory  ", style: TextStyle(fontWeight: FontWeight.bold),)),
            const Text("  /  "),
            show? Text(text) : SizedBox(),
          ],
        ),
        const Divider(
          color: Colors.black,
          thickness: .8,
        ),
      ],
    );
  }
}
