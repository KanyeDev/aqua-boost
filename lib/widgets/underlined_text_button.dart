import 'package:flutter/material.dart';

import '../utilities/toast.dart';

class UnderlinedTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const UnderlinedTextButton({
    super.key,
    required this.text, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))),
          child: Text(
            text,
          )),
    );
  }
}
