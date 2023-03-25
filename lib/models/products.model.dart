import 'package:flutter/cupertino.dart';

import 'categories_model.dart';

class ProductsModel with ChangeNotifier {
  ProductsModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.images,
  });

  int? id;
  String? title;
  int? price;
  String? description;
  CategoriesModel? category;
  List<String>? images;

  static ProductsModel fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      category: json['category'] != null //
          ? CategoriesModel.fromJson(json['category'])
          : null,
      images: json['images'].cast<String>(),
    );
  }

  static List<ProductsModel> productsFromList(List<Map<String, dynamic>> products) {
    return products.map(ProductsModel.fromJson).toList();
  }
}
