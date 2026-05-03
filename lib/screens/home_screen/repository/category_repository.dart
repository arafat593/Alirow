import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/screens/product_details/model/product_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class CategoryRepository {
  CategoryRepository._privateConstructor();
  static final CategoryRepository _instance =
      CategoryRepository._privateConstructor();
  static CategoryRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<List<CategoryModel>> getCategories({
    int page = 1,
    int limit = 100,
  }) async {
    List<CategoryModel> categories = [];
    try {
      var response = await _apiServices.getServices(
        _api.categories,
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response != null && response['data'] != null) {
        if (response['data'] is Map && response['data']['result'] is List) {
          for (var element in response['data']['result']) {
            categories.add(CategoryModel.fromJson(element as Map<String, dynamic>));
          }
        } else if (response['data'] is List) {
          for (var element in response['data']) {
            categories.add(CategoryModel.fromJson(element as Map<String, dynamic>));
          }
        }
      }
    } catch (e) {
      errorLog('getCategories repo', e);
    }
    return categories;
  }
}
