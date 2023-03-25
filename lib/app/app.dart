import 'package:eccomerce_shop_app/consts/global_colors.dart';
import 'package:eccomerce_shop_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_handler.dart';

enum AppEnv {
  dev,
  prod;
}

class EcommerceApp extends StatefulWidget {
  const EcommerceApp({
    Key? key,
    required this.appEnv,
  }) : super(key: key);

  final AppEnv appEnv;

  @override
  State<EcommerceApp> createState() => _EcommerceAppState();
}

class _EcommerceAppState extends State<EcommerceApp> {
  ThemeData buildTheme() {
    var theme = ThemeData(
      scaffoldBackgroundColor: lightScaffoldColor,
      primaryColor: lightCardColor,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: lightIconsColor,
        ),
        backgroundColor: lightScaffoldColor,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightTextColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      iconTheme: IconThemeData(
        color: lightIconsColor,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
        selectionColor: Colors.blue,
      ),
      cardColor: lightCardColor,
      brightness: Brightness.light,
    );
    return theme.copyWith(
      colorScheme: theme.colorScheme
          .copyWith(
            secondary: lightIconsColor,
            brightness: Brightness.light,
          )
          .copyWith(background: lightBackgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ApiHandler>(
      create: (BuildContext context) {
        return ApiHandler();
      },
      dispose: (BuildContext context, ApiHandler apiHandler) {
        apiHandler.dispose();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: widget.appEnv == AppEnv.dev,
        title: 'Flutter 3.0.4 ',
        theme: buildTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}
