
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'inkwell_button.dart';

Stack wideFlatButton(String text, IconData icon, VoidCallback onTap,
    VoidCallback? Function(bool value) onHover, Color color) {
  return Stack(children: [
    CustomInkWellButton(const Duration(milliseconds: 150), 15, Alignment.center,
        33, 205, text, false, color, Colors.black, onTap, onHover),
    Positioned(
        left: 12,
        top: 3,
        child: Icon(
          icon,
          size: 25,
        )),
  ]);
}
