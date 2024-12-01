import 'package:eccomerce_shop_app/services/api_handler.dart';
import 'package:eccomerce_shop_app/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/users_model.dart';
import '../widgets/data_loader.dart';
import '../widgets/users_widget.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen._({Key? key}) : super(key: key);

  static Route<void> route() {
    return PageTransition(
      type: PageTransitionType.fade,
      child: const UsersScreen._(),
    );
  }

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<UsersModel>> _futureUsers;
  List<UsersModel>? _users;

  @override
  void initState() {
    super.initState();
    _futureUsers = ApiHandler.of(context).getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Users"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      ),
      body: DataLoader<List<UsersModel>>(
        loader: _futureUsers,
        emptyMessage: 'No users',
        builder: (BuildContext context, List<UsersModel> users) {
          _users ??= users;
          final padding = MediaQuery.of(context).padding;
          return ListView.builder(
            padding: EdgeInsets.only(top: padding.top) + //
                horizontalPadding8 +
                topPadding8,
            itemCount: _users!.length,
            itemBuilder: (BuildContext context, int index) {
              final user = _users![index];
              return Padding(
                padding: bottomPadding8,
                child: UsersWidget(
                  key: Key('user-${user.id}'),
                  user: user,
                  //onDelete: () {
                  //  setState(() {
                  //    _users!.remove(user);
                  //  });
                  //},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
