import 'package:college_notees/models/background_color.dart';
import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static schowSnackBar(String text) {
    if (text == '') return;

    final snackBar = SnackBar(content: Text(text));

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Widget addVerticalSpace(double value) {
    return SizedBox(
      height: value,
    );
  }

  static Widget addHorizontalSpace(double value) {
    return SizedBox(
      width: value,
    );
  }

  static Widget addSpace() {
    return const Spacer();
  }

  static String toCapitalization(String text) {
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String strDigits(int n) => n.toString().padLeft(2, '0');

  static List<BackgroundColor> backgroundColors = [
    BackgroundColor(
        primary: const Color(0xffBBC4FF), secondary: const Color(0xffA1AEF7)),
    BackgroundColor(
        primary: const Color(0xffA5D6A7), secondary: const Color(0xff81C784)),
    BackgroundColor(
        primary: const Color(0xffFFF59D), secondary: const Color(0xffFFF176)),
    BackgroundColor(
        primary: const Color(0xffEF9A9A), secondary: const Color(0xffE57373)),
    BackgroundColor(
        primary: const Color(0xffCE93D8), secondary: const Color(0xffBA68C8)),
    BackgroundColor(
        primary: const Color(0xffF48FB1), secondary: const Color(0xffF06292)),
    BackgroundColor(
        primary: const Color(0xff80CBC4), secondary: const Color(0xff4DB6AC)),
    BackgroundColor(
        primary: const Color(0xffFFAB91), secondary: const Color(0xffFF8A65)),
    BackgroundColor(
        primary: const Color(0xffBCAAA4), secondary: const Color(0xffA1887F)),
    BackgroundColor(
        primary: const Color(0xffFFE082), secondary: const Color(0xffFFD54F)),
    BackgroundColor(
        primary: const Color(0xffFFCC80), secondary: const Color(0xffFFB74D)),
    BackgroundColor(
        primary: const Color(0xffC5E1A5), secondary: const Color(0xffAED581)),
    BackgroundColor(
        primary: const Color(0xffE6EE9C), secondary: const Color(0xffDCE775)),
    BackgroundColor(
        primary: const Color(0xff81D4FA), secondary: const Color(0xff4FC3F7)),
    BackgroundColor(
        primary: const Color(0xffB39DDB), secondary: const Color(0xff9575CD)),
    BackgroundColor(
        primary: const Color(0xff9FA8DA), secondary: const Color(0xff7986CB)),
  ];
}
