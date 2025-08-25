import '../urls/api_endpoints.dart';
import 'api_interceptor.dart';
import 'package:dio/dio.dart';

class ApiManager {
  Dio dio = Dio();
  ApiManager() {
    // dio.options.contentType=Headers.jsonContentType;
    dio.options.connectTimeout = const Duration(seconds: 30);
    // dio.options.connectTimeout = const Duration(milliseconds: 10000);
    dio.options.baseUrl = ApiEndpoints.baseUrl;
    dio.options.headers.addAll({'Content-Type': 'application/json'});
    dio.interceptors.add(ApiInterceptor());
  }
}