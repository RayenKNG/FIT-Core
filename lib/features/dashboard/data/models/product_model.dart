// Sesuai modul hal.37 & 41
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final double priceOriginal;
  final int stock;
  final String badge;
  final String emoji;
  final String gradientFrom;
  final String gradientTo;
  final bool isFeatured;
  final bool isActive;
  final int soldCount;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.priceOriginal,
    required this.stock,
    required this.badge,
    required this.emoji,
    required this.gradientFrom,
    required this.gradientTo,
    required this.isFeatured,
    required this.isActive,
    required this.soldCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['ID'] as int? ?? json['id'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    priceOriginal: (json['price_original'] as num?)?.toDouble() ?? 0.0,
    stock: json['stock'] as int? ?? 0,
    badge: json['badge'] as String? ?? 'none',
    emoji: json['emoji'] as String? ?? '💪',
    gradientFrom: json['gradient_from'] as String? ?? '#7C3AED',
    gradientTo: json['gradient_to'] as String? ?? '#EC4899',
    isFeatured: json['is_featured'] as bool? ?? false,
    isActive: json['is_active'] as bool? ?? true,
    soldCount: json['sold_count'] as int? ?? 0,
  );

  // Discount percentage
  double get discountPct {
    if (priceOriginal <= 0 || priceOriginal <= price) return 0;
    return ((priceOriginal - price) / priceOriginal * 100).roundToDouble();
  }

  // Format harga Rupiah
  String get formattedPrice =>
      'Rp ${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  @override
  List<Object?> get props => [id, name, price];
}
