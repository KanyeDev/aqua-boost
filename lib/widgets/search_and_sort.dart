import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchAndSort extends StatelessWidget {
  const SearchAndSort({
    super.key, required this.text, required this.onPressed, required this.editController, required this.onEditTap,
  });

  final String text;
  final VoidCallback onPressed;
  final VoidCallback? Function(String value) onEditTap ;
  final TextEditingController editController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Expanded(child: SizedBox()),
        Container(
          height: 30,
          width: 200,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: editController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                icon: Icon(
                  Icons.search,
                  color: Colors.black38,
                ),
              ), onChanged: onEditTap, ),
        ),
        const Gap(20),
        Container(
          height: 30,
          width: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(10)),
          child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Sort",
                icon: Icon(
                  Icons.sort_by_alpha,
                  color: Colors.black38,
                ),
              ),
              onTap: () {}),
        ),
        const Gap(20),
         InkWell(onTap: onPressed, child: const Icon(Icons.print, color:  Color(0xffB6D69E),size: 40,))
      ],
    );
  }
}