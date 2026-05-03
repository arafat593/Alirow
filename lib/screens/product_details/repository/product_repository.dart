import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/screens/product_details/model/product_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class ProductRepository {
  ProductRepository._privateConstructor();
  static final ProductRepository _instance =
      ProductRepository._privateConstructor();
  static ProductRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? search,
  }) async {
    List<ProductModel> products = [];
    try {
      Map<String, dynamic> query = {'page': page, 'limit': limit};
      if (categoryId != null && categoryId.isNotEmpty) {
        query['categoryId'] = categoryId;
      }
      if (search != null && search.isNotEmpty) {
        query['search'] = search;
      }

      var response = await _apiServices.getServices(
        _api.products,
        queryParameters: query,
      );

      if (response != null && response['data'] != null) {
        if (response['data'] is Map && response['data']['result'] is List) {
          for (var element in response['data']['result']) {
            products.add(ProductModel.fromJson(element));
          }
        } else if (response['data'] is List) {
          for (var element in response['data']) {
            products.add(ProductModel.fromJson(element));
          }
        }
      }
    } catch (e) {
      errorLog('getProducts repo', e);
    }
    return products;
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      var response = await _apiServices.getServices('${_api.products}/$id');
      if (response != null) {
        if (response['data'] != null && response['data'] is Map) {
          return ProductModel.fromJson(
            response['data'] as Map<String, dynamic>,
          );
        }
      }
    } catch (e) {
      errorLog('getProductById repo', e);
    }
    return null;
  }
}
