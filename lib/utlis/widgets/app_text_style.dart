import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  /// Nunito Regular
  static TextStyle nunitoRegular(double fontSize, {Color color = Colors.black}) {
    return GoogleFonts.nunito(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  /// Nunito Medium
  static TextStyle nunitoMedium(double fontSize, {Color color = Colors.black}) {
    return GoogleFonts.nunito(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  /// Nunito Bold
  static TextStyle nunitoBold(double fontSize, {Color color = Colors.black}) {
    return GoogleFonts.nunito(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: color,
    );
  }

  /// Lato Regular
  static TextStyle latoRegular(double fontSize, {Color color = Colors.black}) {
    return GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  /// Lato Medium
  static TextStyle latoMedium(double fontSize, {Color color = Colors.black}) {
    return GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  /// Lato Bold
  static TextStyle latoBold(double fontSize, {Color color = Colors.black}) {
    return GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }
}
