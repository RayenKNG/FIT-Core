import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts({
    int page,
    int limit,
    String? category,
    String? search,
  });
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> getFeatured();
}
