import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../data/models/product_model.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    final response = await DioClient.instance.get(
      ApiConstants.products,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
        if (search != null) 'q': search,
      },
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await DioClient.instance.get(
      '${ApiConstants.products}/$id',
    );
    return ProductModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ProductModel>> getFeatured() async {
    final response = await DioClient.instance.get(ApiConstants.featured);
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
