import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/categories_model.dart';
import '../services/api_handler.dart';
import '../widgets/category_widget.dart';
import '../widgets/data_loader.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen._({Key? key}) : super(key: key);

  static Route<void> route() {
    return PageTransition(
      type: PageTransitionType.fade,
      child: const CategoriesScreen._(),
    );
  }

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<CategoriesModel>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = ApiHandler.of(context).getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: DataLoader<List<CategoriesModel>>(
        loader: _futureCategories,
        emptyMessage: 'No categories',
        builder: (BuildContext context, List<CategoriesModel> categories) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return CategoryWidget(
                category: categories[index],
              );
            },
          );
        },
      ),
    );
  }
}
