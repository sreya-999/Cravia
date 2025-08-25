import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:ravathi_store/models/banner_model.dart';
import 'package:ravathi_store/models/category_models.dart';
import '../models/items_model.dart';
import '../models/login_model.dart';
import '../models/product_model.dart';
import '../urls/api_endpoints.dart';
import '../utlis/constant/constants.dart';
import '../utlis/share_preference_helper/sharereference_helper.dart';
import '../utlis/widgets/snack_bar.dart';
import 'api_manager.dart';
import 'error_handler.dart';

class DownloadManager {
  static ApiManager apiManager = ApiManager();
  final locator = getIt.get<SharedPreferenceHelper>();
  static final sharedPreferenceHelper = getIt.get<SharedPreferenceHelper>();
  static ShowSnackBar showSnackBar=ShowSnackBar();


  /// getBanner
  Future<List<BannerModel>?> getBanner(BuildContext context) async {
    try {
      final response = await apiManager.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.banner}',
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = response.data['data'];
        print('timeslot: $data');

        List<BannerModel> timeSlotlIST = data.map((e) => BannerModel.fromJson(e)).toList();

        print('timeslot: $timeSlotlIST');
        return timeSlotlIST;
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
      return null;
    }
  }

  /// getCategoryItems
  Future<List<Item>?> getCategoryItems(BuildContext context, int? categoryId) async {
    try {
      final response = await apiManager.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.dashBoard}',
        queryParameters: categoryId != null ? {'category_id': categoryId} : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data; // Already a decoded Map
        if (data['data'] != null && data['data']['items'] != null) {
          // Parse the list of items
          final List itemsJson = data['data']['items'] as List;
          return itemsJson.map((json) => Item.fromJson(json)).toList();
        } else {
          debugPrint('No items found in response');
          return [];
        }
      } else {
        debugPrint('Unexpected status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
      return null;
    }
  }

  /// searchText
  Future<List<Item>?> searchText(BuildContext context, String? searchText) async {
    try {
      final response = await apiManager.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.dashBoard}',
        queryParameters: searchText != null ? {'search': searchText} : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['data'] != null && data['data']['items'] != null) {
          final List itemsJson = data['data']['items'] as List;
          return itemsJson.map((json) => Item.fromJson(json)).toList();
        } else {
          debugPrint('No items found in response');
          return [];
        }
      } else {
        debugPrint('Unexpected status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
      return null;
    }
  }

/// getCategory
  Future<List<CategoryModel>?> getCategory(BuildContext context) async {
    try {
      final response = await apiManager.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.category}',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data; // Already a decoded Map
        if (data['data'] != null && data['data'] != null) {
          final categoriesJson = data['data'] as List;
          return categoriesJson
              .map((json) => CategoryModel.fromJson(json))
              .toList();
        }
        return [];
      } else {
        debugPrint('Unexpected status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
      return null;
    }
  }

  Future<List<Item>?> bugOneGetOne(BuildContext context, String? searchText) async {
    try {
      final response = await apiManager.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.buyOneGetOne}',
        queryParameters: searchText != null ? {'search': searchText} : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['data'] != null && data['data']['items'] != null) {
          final List itemsJson = data['data']['items'] as List;
          return itemsJson.map((json) => Item.fromJson(json)).toList();
        } else {
          debugPrint('No items found in response');
          return [];
        }
      } else {
        debugPrint('Unexpected status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
      return null;
    }
  }

  Future<List<Item>?> getComboOffer(BuildContext context, String? searchText) async {
    try {
      final response = await apiManager.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.combo}',
        queryParameters: searchText != null ? {'search': searchText} : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['data'] != null && data['data']['items'] != null) {
          final List itemsJson = data['data']['items'] as List;
          return itemsJson.map((json) => Item.fromJson(json)).toList();
        } else {
          debugPrint('No items found in response');
          return [];
        }
      } else {
        debugPrint('Unexpected status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      ErrorHandler.handleError(context, e);
      return null;
    }
  }

}
