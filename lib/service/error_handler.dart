import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import '../utlis/widgets/snack_bar.dart';

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    final snackBar = ShowSnackBar();

    if (error is DioException) {
      print('DioException occurred: ${error.message}');
      print('Response: ${error.response}');
      print('Error type: ${error.type}');

      String message = 'Something went wrong';

      dynamic data = error.response?.data;


      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {}
      }

      // ✅ Try extracting message from decoded JSON (if possible)
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? message;
      }

      // ✅ If that fails, fall back to error.message (which you saw has the correct string!)
      if (message == 'Something went wrong' && error.message != null) {
        try {
          final decoded = jsonDecode(error.message!);
          if (decoded is Map && decoded['message'] != null) {
            message = decoded['message'];
          } else {
            message = error.message!;
          }
        } catch (_) {
          message = error.message!;
        }
      }

      snackBar.customSnackBar(
        context: context,
        type: "0",
        strMessage: message,
      );
    } else {
      snackBar.customSnackBar(
        context: context,
        type: "0",
        strMessage: 'Unexpected error: ${error.toString()}',
      );
    }
  }

}