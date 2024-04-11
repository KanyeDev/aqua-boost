import 'package:flutter/material.dart';


InkWell CustomInkWellButton(Duration duration,double radius,AlignmentGeometry align ,double height, double width, String text, bool isLoading, Color buttonColor, Color textColor,  VoidCallback onTap, VoidCallback? Function(bool value) onHover, ) {
  return InkWell(
    onTap: onTap,
    onHover: onHover,
    child: AnimatedContainer(
      duration: duration,
      height: height,
      width: width,
      alignment: align,
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(radius), ),
      child:  isLoading? const SizedBox(height: 28, width: 28 , child: CircularProgressIndicator(color: Colors.white, )):  Text(
        text,
        style:  TextStyle(
            color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}


