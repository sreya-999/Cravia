import 'package:flutter/material.dart';

class AppFonts {
  AppFonts._();

  static const String fontInter = 'inter';
  static const String fontPoppins = 'Poppins';
  static const String fontReemKufi = 'Reem Kufi';
  static const String fontLobster = 'Lobster';
  static const String fontOleoScriptSwashCaps = 'OleoScriptSwashCaps'; // ✅ New font
}

class AppStyle {
  AppStyle._();

  // Inter styles
  static const TextStyle textStyle400 = TextStyle(
    fontFamily: AppFonts.fontInter,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle textStyle500 = TextStyle(
    fontFamily: AppFonts.fontInter,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle textStyle600 = TextStyle(
    fontFamily: AppFonts.fontInter,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle textStyle700 = TextStyle(
    fontFamily: AppFonts.fontInter,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle textStyle800 = TextStyle(
    fontFamily: AppFonts.fontInter,
    fontWeight: FontWeight.w800,
  );

  // Poppins styles
  static const TextStyle textStylePoppins300 = TextStyle(
    fontFamily: AppFonts.fontPoppins,
    fontWeight: FontWeight.w300,
  );
  static const TextStyle textStylePoppins400 = TextStyle(
    fontFamily: AppFonts.fontPoppins,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle textStylePoppins500 = TextStyle(
    fontFamily: AppFonts.fontPoppins,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle textStylePoppins600 = TextStyle(
    fontFamily: AppFonts.fontPoppins,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle textStylePoppins700 = TextStyle(
    fontFamily: AppFonts.fontPoppins,
    fontWeight: FontWeight.w700,
  );

  // Reem Kufi styles
  static const TextStyle textStyleReemKufi = TextStyle(
    fontFamily: AppFonts.fontReemKufi,
    fontWeight: FontWeight.w400,
  );

  // Lobster styles
  static const TextStyle textStyleLobster = TextStyle(
    fontFamily: AppFonts.fontLobster,
    fontWeight: FontWeight.w400,
  );

  // ✅ Oleo Script Swash Caps styles
  static const TextStyle textStyleOleoScriptSwashCaps = TextStyle(
    fontFamily: AppFonts.fontOleoScriptSwashCaps,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle textStyleOleoScriptSwashCapsBold = TextStyle(
    fontFamily: AppFonts.fontOleoScriptSwashCaps,
    fontWeight: FontWeight.w700,
  );
}
