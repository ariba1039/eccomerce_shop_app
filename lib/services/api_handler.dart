import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart' show BuildContext;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/categories_model.dart';
import '../models/products.model.dart';
import '../models/users_model.dart';

final _baseUrl = Uri.parse("https://api.escuelajs.co");

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;
}

class ApiHandler {
  ApiHandler();

  void dispose() {
    // clean up api resources
  }

  static ApiHandler of(BuildContext context) {
    return Provider.of<ApiHandler>(context, listen: false);
  }

  Future<List<ProductsModel>> getAllProducts({required int limit}) async {
    final List<dynamic> products =
        await _callApiFunction("products", {'offset': 0, 'limit': limit});
    return ProductsModel.productsFromList(products.cast());
  }

  Future<ProductsModel> getProductById(int id) async {
    return ProductsModel.fromJson(await _callApiFunction("products/$id"));
  }

  Future<List<CategoriesModel>> getAllCategories() async {
    final List<dynamic> categories = await _callApiFunction("categories");
    return CategoriesModel.categoriesFromList(categories.cast());
  }

  Future<List<UsersModel>> getAllUsers() async {
    final List<dynamic> users = await _callApiFunction("users");
    return UsersModel.usersFromList(users.cast());
  }

  Future<dynamic> _callApiFunction(String function, [Map<String, dynamic>? parameters]) async {
    final requestUri = _baseUrl.replace(
      path: "api/v1/$function",
      queryParameters: {
        if (parameters != null) //
          for (final key in parameters.keys) //
            key: parameters[key].toString(),
      },
    );
    final response = await http.get(
      requestUri,
      headers: {
        HttpHeaders.acceptHeader: ContentType.json.mimeType,
      },
    );
    final contentTypeHeader = response.headers[HttpHeaders.contentTypeHeader];
    if (contentTypeHeader != null) {
      final contentType = ContentType.parse(contentTypeHeader);
      if (contentType.mimeType != ContentType.json.mimeType) {
        throw const ApiException("Invalid response");
      }
    }
    final body = json.decode(response.body);
    if (response.statusCode != HttpStatus.ok) {
      throw ApiException(
        body["message"] ?? 'Invalid status: ${response.statusCode}',
      );
    }
    return body;
  }
}
