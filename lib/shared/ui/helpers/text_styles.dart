import 'package:flutter/material.dart';
// ignore: avoid_classes_with_only_static_members
class TextStyles {
  static final baseText = TextStyle(
    fontSize: 20,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    color: Colors.black
  );

  static final header = baseText.copyWith(
      fontWeight: FontWeight.w500, fontSize: 42);

  static final subtitle = baseText.copyWith(
      fontWeight: FontWeight.w400, fontSize: 14);


  static final cardHeader = baseText.copyWith(
      fontWeight: FontWeight.w700, fontSize: 20);
  static final cardContent = baseText.copyWith(
      fontWeight: FontWeight.w200, fontSize: 12);
  static final title = baseText.copyWith(
      fontWeight: FontWeight.w700, fontSize: 30);


}
