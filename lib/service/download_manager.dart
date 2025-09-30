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
  Future<List<Item>?> getCategoryItems(BuildContext context, int? categoryId, String? sortBy,String? searchText) async {
    try {
      final queryParams = <String, dynamic>{};

      if (categoryId != null && categoryId != -1) {
        queryParams['category_id'] = categoryId;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sort_by'] = sortBy;
      }
      if (searchText != null && searchText.isNotEmpty) {
        queryParams['search'] = searchText;
      }
      final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.dashBoard}';
      print('➡️ Base URL: $url');
      print('➡️ Query Params: $queryParams'); // prints categoryId + sortBy if set

      final response = await apiManager.dio.get(
        url,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
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
  Future<List<Item>?> searchText(BuildContext context, String? searchText, int? categoryId) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null && categoryId != -1) {
        queryParams['category_id'] = categoryId;
      }

      if (searchText != null && searchText.isNotEmpty) {
        queryParams['search'] = searchText;
      }


      final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.dashBoard}';

      // // 👇 Convert params to query string
      // final queryString = params.entries.map((e) => "${e.key}=${e.value}").join("&");
      // final fullUrl = queryString.isNotEmpty ? "$url?$queryString" : url;

      // Print final URL
      print("Request URL: $url");

      final response = await apiManager.dio.get(
        url,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
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

  // Future<List<Item>?> bugOneGetOne(BuildContext context, String? searchText) async {
  //   try {
  //     final params = {
  //       if (searchText != null && searchText.isNotEmpty) 'search': searchText,
  //     };
  //
  //
  //     final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.buyOneGetOne}';
  //
  //     // 👇 Convert params to query string
  //     final queryString = params.entries.map((e) => "${e.key}=${e.value}").join("&");
  //     final fullUrl = queryString.isNotEmpty ? "$url?$queryString" : url;
  //
  //     // Print final URL
  //     print("Request URL: $fullUrl");
  //
  //     print("🔗 Base URL: $url");
  //     final response = await apiManager.dio.get(
  //       url,
  //       queryParameters: params,
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = response.data;
  //       if (data['data'] != null && data['data']['items'] != null) {
  //         final List itemsJson = data['data']['items'] as List;
  //         return itemsJson.map((json) => Item.fromJson(json)).toList();
  //       } else {
  //         debugPrint('No items found in response');
  //         return [];
  //       }
  //     } else {
  //       debugPrint('Unexpected status code: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     ErrorHandler.handleError(context, e);
  //     return null;
  //   }
  // }

  Future<List<Item>?> bugOneGetOne(BuildContext context, String? searchText,String? sortBy) async {
    try {
      final params = {
        if (searchText != null && searchText.isNotEmpty) 'search': searchText,
        if(sortBy != null && sortBy.isNotEmpty)'sort_by':sortBy
      };


      final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.buyOneGetOne}';

      // 👇 Convert params to query string
      final queryString = params.entries.map((e) => "${e.key}=${e.value}").join("&");
      final fullUrl = queryString.isNotEmpty ? "$url?$queryString" : url;

      // Print final URL
      print("Request URL: $fullUrl");

      final response = await apiManager.dio.get(
        url,
        queryParameters: params,
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

  Future<List<Item>?> bugOneGetOneOfferSearch(BuildContext context,String? searchText) async {
    try {
      final params = {
        if(searchText != null && searchText.isNotEmpty)'search':searchText
      };


      final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.buyOneGetOne}';

      // 👇 Convert params to query string
      final queryString = params.entries.map((e) => "${e.key}=${e.value}").join("&");
      final fullUrl = queryString.isNotEmpty ? "$url?$queryString" : url;

      // Print final URL
      print("Request URL: $fullUrl");

      final response = await apiManager.dio.get(
        url,
        queryParameters: params,
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

  Future<List<ComboProductModel>?> getComboOffer(BuildContext context, String? searchText,String? sortBy) async {
    try {
      final Map<String, dynamic> queryParams = {};

      if (searchText != null && searchText.isNotEmpty) {
        queryParams['search'] = searchText;
      }

      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sort_by'] = sortBy;
      }
      print('➡️ API URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.combo}');
      print('➡️ Query Params: $queryParams');
      final response = await apiManager.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.combo}',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['data'] != null && data['data']['items'] != null) {
          final List itemsJson = data['data']['items'] as List;
          return itemsJson.map((json) => ComboProductModel.fromJson(json)).toList();
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
