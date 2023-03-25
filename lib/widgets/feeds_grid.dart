import 'package:flutter/material.dart';

import '../models/products.model.dart';
import 'common.dart';
import 'feeds_widget.dart';

class FeedsGridWidget extends StatelessWidget {
  const FeedsGridWidget({
    Key? key,
    required this.productsList,
  }) : super(key: key);

  final List<ProductsModel> productsList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < productsList.length; i += 2) //
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 0.6,
                  child: FeedsWidget(
                    product: productsList[i],
                  ),
                ),
              ),
              if ((i + 1) < productsList.length) //
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 0.6,
                    child: FeedsWidget(
                      product: productsList[i + 1],
                    ),
                  ),
                )
              else
                const Expanded(
                  child: emptyWidget,
                ),
            ],
          ),
      ],
    );
  }
}
