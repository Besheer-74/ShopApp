import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class BannerAd {
  final int id;
  final String image;
  String? localImagePath;

  BannerAd({
    required this.id,
    required this.image,
    this.localImagePath,
  });
  factory BannerAd.fromJson(Map<String, dynamic> json) => BannerAd(
        id: json['id'] as int,
        image: json['image'] as String,
      );

  Future<void> cacheImagesBanner() async {
    if (localImagePath == null) {
      var file = await DefaultCacheManager().getSingleFile(image);
      localImagePath = file.path;
    }
  }
}

class Category {
  final int id;
  final String name;
  final String image;
  String? localImagePath;

  Category({
    required this.id,
    required this.name,
    required this.image,
    this.localImagePath,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int,
        name: json['name'],
        image: json['image'] as String,
      );

  Future<void> cacheImagesCategory() async {
    if (localImagePath == null) {
      var file = await DefaultCacheManager().getSingleFile(image);
      localImagePath = file.path;
    }
  }
}

class Product {
  final int id;
  final dynamic price;
  final dynamic oldPrice;
  final dynamic discount;
  final String image;
  final String name;
  final String description;
  final List<String> images;
  String? localImagePath;
  bool isFav = false;

  Product({
    required this.id,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.image,
    required this.name,
    required this.description,
    required this.images,
    this.localImagePath,
    this.isFav = false,
  });
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        price: json['price'] as dynamic,
        oldPrice: json['old_price'] as dynamic,
        discount: json['discount'] as dynamic,
        image: json['image'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        images: (json['images'] as List).cast<String>(),
      );
  Future<void> cacheImagesProduct() async {
    if (localImagePath == null) {
      var file = await DefaultCacheManager().getSingleFile(image);
      localImagePath = file.path;
    }
  }
}
