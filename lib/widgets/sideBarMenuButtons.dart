import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'inkwell_button.dart';

Row sideBarMenuButtons(bool extend,String text, bool visibility, IconData icon,VoidCallback onTap, VoidCallback? Function(bool value) onHover, Color color) {
  return Row(
    children: [
      const SizedBox(
        width: 20,
      ),
      Icon(icon),
      extend
          ? Visibility(
        visible: visibility,
        child: Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: CustomInkWellButton(const Duration(milliseconds: 200),4,
              const FractionalOffset(0.1, 1),
              27,
              120,
              text,
              false,
              color,
              Colors.black, onTap, onHover),
        ),
      )
          : const SizedBox()
    ],
  );
}