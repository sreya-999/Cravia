import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/order_model.dart';
import '../models/otp_response.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../urls/api_endpoints.dart';
import '../utlis/share_preference_helper/sharereference_helper.dart';
import '../utlis/widgets/snack_bar.dart';
import 'api_manager.dart';
import 'error_handler.dart';

class SyncManager{
  static ApiManager apiManager = ApiManager();
  final locator = getIt.get<SharedPreferenceHelper>();
  static final sharedPreferenceHelper = getIt.get<SharedPreferenceHelper>();
  static ShowSnackBar showSnackBar=ShowSnackBar();


  static Future<int?> login(BuildContext context, String? mobile) async {
    try {
      final response = await apiManager.dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.login}?mobile=$mobile',
      );

      if (response.statusCode == 200) {
        final otpResponse = OtpResponse.fromJson(response.data);
        print("Message: ${otpResponse.message}");
        print("OTP: ${otpResponse.otp}");
        return otpResponse.otp; // ✅ Return OTP
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
      return null;
    }
  }



  static Future<int?> verifyOtp(BuildContext context, String? mobile,int? otp) async {
    try {
      final response = await apiManager.dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.verifyOTP}?mobile=$mobile&otp=$otp',
      );

      if (response.statusCode == 200) {
        final data = response.data is Map ? response.data : jsonDecode(response.data.toString());
        final otpResponse = UserModel.fromJson(data);

        print("Message: ${otpResponse.message}");
        print("User ID: ${otpResponse.userId}");
        return otpResponse.userId;// ✅ Return OTP
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
      return null;
    }
  }

  static Future<OrderModel?> placeOrder(
      BuildContext context,
      int? customerId,
      double? total,
      List<CartItemModel> cartItems,
      ) async {
    try {
      final prefHelper = getIt<SharedPreferenceHelper>();
      final orderType =
      prefHelper.readData(key: StorageKey.dineInOption) as String?;

      Map<String, dynamic> requestBody = {
        "customer_id": customerId,
        "cart": cartItems.map((item) => item.toJson()).toList(),
        "total_price": total,
        "order_type": orderType,
      };

      const uri = '${ApiEndpoints.baseUrl}${ApiEndpoints.placeOrder}';
      print("Place Order URI: $uri");
      print("Place Order Request Body JSON: ${jsonEncode(requestBody)}");

      final response = await apiManager.dio.post(uri, data: requestBody);

      if (response.statusCode == 201) {
        final data = response.data['data'];
        print('Raw response data: $data');

        // Map to OrderModel
        final order = OrderModel.fromJson(data);
        print('Order ID: ${order.orderId}, Order No: ${order.orderNo}, Amount: ${order.amount}');
        return order;
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
      return null;
    }
  }
}