import 'package:flutter/material.dart';

class CategoriesModel with ChangeNotifier {
  CategoriesModel({this.id, this.name, this.image});

  int? id;
  String? name;
  String? image;

  static CategoriesModel fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  static List<CategoriesModel> categoriesFromList(List<Map<String, dynamic>> categories) {
    return categories.map(CategoriesModel.fromJson).toList();
  }
}
