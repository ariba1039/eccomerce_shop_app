import 'package:eccomerce_shop_app/widgets/common.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../consts/global_colors.dart';
import '../models/users_model.dart';

class UsersWidget extends StatelessWidget {
  const UsersWidget({
    Key? key,
    this.onDelete,
    required this.user,
  }) : super(key: key);

  final VoidCallback? onDelete;
  final UsersModel user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FancyShimmerImage(
          width: 54.0,
          height: 54.0,
          errorWidget: const Icon(
            IconlyBold.danger,
            color: Colors.red,
            size: 28,
          ),
          imageUrl: user.avatar,
          boxFit: BoxFit.fill,
        ),
        horizontalMargin16,
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name),
              verticalMargin4,
              Text(user.email),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              user.role,
              style: TextStyle(
                color: lightIconsColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onDelete != null) //
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete),
              ),
          ],
        ),
      ],
    );
  }
}
