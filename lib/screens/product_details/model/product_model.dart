class ProductModel {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String thumbnail;
  final List<String> images;
  final double price;
  final String status;
  final double? discount;
  final String? discountType;
  final int? stock;
  final bool isFeatured;
  final String createdAt;
  final String updatedAt;
  final String categoryId;
  final CategoryModel? category;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.thumbnail,
    required this.images,
    required this.price,
    required this.status,
    this.discount,
    this.discountType,
    this.stock,
    required this.isFeatured,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      thumbnail: json['thumbnail']?.toString() ?? '',
      images: json['images'] is List
          ? List<String>.from((json['images'] as List).map((e) => e.toString()))
          : [],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? '',
      discount: (json['discount'] as num?)?.toDouble(),
      discountType: json['discountType']?.toString(),
      stock: json['stock'] as int?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  /// All images including thumbnail for the image slider
  List<String> get allImages {
    final list = <String>[];
    if (thumbnail.isNotEmpty) list.add(thumbnail);
    list.addAll(images);
    return list;
  }

  /// Sale price after discount
  double get salePrice {
    if (discount == null || discount == 0) return price;
    if (discountType == 'PERCENTAGE') {
      return price - (price * discount! / 100);
    }
    // FIXED discount
    return price - discount!;
  }

  bool get hasDiscount => discount != null && discount! > 0;
}

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String image;
  final bool isFeatured;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.isFeatured,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}
