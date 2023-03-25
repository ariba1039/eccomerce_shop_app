import 'package:flutter/material.dart';

import '../models/products.model.dart';
import '../services/api_handler.dart';
import '../widgets/feeds_grid.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ProductsModel> productsList = [];
  int limit = 10;
  bool _isLoading = false;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // getProducts();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _isLoading = true;
        print("_isLoading $_isLoading");
        limit += 10;
        await getProducts();
        _isLoading = false;
        print("limit $limit");
      }
    });
  }

  Future<void> getProducts() async {
    productsList = await ApiHandler.of(context).getAllProducts(limit: limit);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 4,
        title: const Text('All Products'),
      ),
      body: productsList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: FeedsGridWidget(
                productsList: productsList,
              ),
            ),
    );
  }
}
