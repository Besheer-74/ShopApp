import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/const.dart';
import '../model/itemmodel.dart';

class GetData {
  List<BannerAd> banner = [];

  List<Category> category = [];

  List<Product> product = [];

  Future<List<BannerAd>> fetchBanner() async {
    var request = await http.get(Uri.parse(shopApi));
    var response =
        convert.jsonDecode(request.body)['data']['banners'] as List<dynamic>;
    print("=================response==========================");
    if (request.statusCode == 200) {
      for (var items in response) {
        banner.add(BannerAd.fromJson(items));
      }
    } else {
      print("=======================Error============================");

      throw (Exception('data failed'));
    }
    return banner;
  }

  Future<List<Category>> fetchCategory() async {
    var request = await http.get(Uri.parse(categoryApi));
    var response =
        convert.jsonDecode(request.body)['data']['data'] as List<dynamic>;
    print("=================response==========================");
    if (request.statusCode == 200) {
      for (var items in response) {
        category.add(Category.fromJson(items));
      }
    } else {
      print("=======================Error============================");

      throw (Exception('data failed'));
    }
    return category;
  }

  Future<List<Product>> fetchProduct() async {
    var request = await http.get(Uri.parse(shopApi));
    var response =
        convert.jsonDecode(request.body)['data']['products'] as List<dynamic>;
    print("=================response==========================");
    if (request.statusCode == 200) {
      for (var items in response) {
        product.add(Product.fromJson(items));
      }
    } else {
      print("=======================Error============================");

      throw (Exception('data failed'));
    }
    return product;
  }
}
