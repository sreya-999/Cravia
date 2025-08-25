import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../utlis/constant/constants.dart';


class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      if (Constants.loginAccessToken != null) {
        options.headers.addAll({
          'Authorization': Constants.loginAccessToken == null
              ? ""
              : 'Bearer ${Constants.loginAccessToken}'
        });
      }
      log("Dio Request:${options.path}\nBody: ${jsonEncode(options.data)}\nHeaders: ${options.headers}");
      return super.onRequest(options, handler);
    } catch (e) {
      return super.onError(
          DioException(
              requestOptions: options,
              type: DioExceptionType.connectionTimeout),
          ErrorInterceptorHandler());
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("Dio Error Response:${err.toString()}");
    log("Dio Error Response:${err.response.toString()}");
    return handler.reject(DioException(
        error: err.response?.data,
        requestOptions: err.requestOptions,
        message: err.response.toString()));
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("Dio Response:${response.data}");
    return super.onResponse(response, handler);
  }
}
