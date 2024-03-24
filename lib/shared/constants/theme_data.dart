import 'package:flutter/material.dart';

class ThemeClass {
  final kInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        color: Color(0xffDADADA),
      ));

  final underBoxShadow = const BoxShadow(
    color: Color(0xffDADADA),
    blurRadius: 8,
    offset: Offset(0, 3),
    spreadRadius: 1,
  );
}
