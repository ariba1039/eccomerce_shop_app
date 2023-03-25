import 'package:card_swiper/card_swiper.dart';
import 'package:eccomerce_shop_app/screens/users_screen.dart';
import 'package:eccomerce_shop_app/widgets/feeds_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:page_transition/page_transition.dart';

import '../consts/global_colors.dart';
import '../models/products.model.dart';
import '../services/api_handler.dart';
import '../widgets/appbar_icons.dart';
import '../widgets/common.dart';
import '../widgets/data_loader.dart';
import '../widgets/sale_widget.dart';
import 'categories_screen.dart';
import 'feeds_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onSearchEntered(String searchQuery) {
    //
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const _HomeAppBar(),
        body: CustomScrollView(
          slivers: [
            _SliverHomeSearchBox(
              onSearchEntered: _onSearchEntered,
            ),
            const _SliverTopProducts(),
            // const SliverRevealContent(),
            sliverVerticalMargin16,
            const _SliverLatestProductsHeader(),
            const _SliverLatestProducts(),
          ],
        ),
      ),
    );
  }
}

@immutable
class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home'),
      leading: AppBarIcon(
        onPressed: () {
          Navigator.of(context).push(CategoriesScreen.route());
        },
        icon: IconlyBold.category,
      ),
      actions: [
        AppBarIcon(
          onPressed: () {
            Navigator.of(context).push(UsersScreen.route());
          },
          icon: IconlyBold.user3,
        ),
      ],
    );
  }
}

@immutable
class _SliverHomeSearchBox extends StatefulWidget {
  const _SliverHomeSearchBox({
    required this.onSearchEntered,
  });

  final ValueChanged<String> onSearchEntered;

  @override
  State<_SliverHomeSearchBox> createState() => _SliverHomeSearchBoxState();
}

class _SliverHomeSearchBoxState extends State<_SliverHomeSearchBox> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  void onTextEntered() {
    widget.onSearchEntered(_textEditingController.text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _SearchBoxDelegate(this),
      floating: true,
    );
  }
}

class _SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  _SearchBoxDelegate(this.state);

  final _SliverHomeSearchBoxState state;

  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant _SearchBoxDelegate oldDelegate) {
    return state != oldDelegate.state;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    return Padding(
      padding: allPadding8 + horizontalPadding8,
      child: Material(
        elevation: overlapsContent ? 8.0 : 0.0,
        borderRadius: BorderRadius.circular(10.0),
        child: TextField(
          controller: state._textEditingController,
          keyboardType: TextInputType.text,
          onSubmitted: (_) => state.onTextEntered(),
          decoration: InputDecoration(
            contentPadding: allPadding12,
            hintText: "Search",
            filled: true,
            fillColor: theme.cardColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: theme.cardColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 1,
                color: theme.colorScheme.secondary,
              ),
            ),
            suffixIcon: Icon(
              IconlyLight.search,
              color: lightIconsColor,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _SliverTopProducts extends StatelessWidget {
  const _SliverTopProducts();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: horizontalPadding8,
        child: SizedBox(
          height: 160.0,
          child: Swiper(
            itemCount: 3,
            itemBuilder: (context, index) {
              return const SalesWidget();
            },
            autoplay: true,
            pagination: const SwiperPagination(
              alignment: Alignment.bottomCenter,
              builder: DotSwiperPaginationBuilder(
                color: Colors.white,
                activeColor: Colors.red,
              ),
            ),
            // control: const SwiperControl(),
          ),
        ),
      ),
    );
  }
}

@immutable
class _SliverLatestProductsHeader extends StatelessWidget {
  const _SliverLatestProductsHeader();

  void _onAllFeedsPressed(BuildContext context) {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.fade,
        child: const FeedsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: horizontalPadding8,
        child: Row(
          children: [
            const Text(
              "Latest Products",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            AppBarIcon(
              onPressed: () => _onAllFeedsPressed(context),
              icon: IconlyBold.arrowRight2,
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class _SliverLatestProducts extends StatefulWidget {
  const _SliverLatestProducts();

  @override
  State<_SliverLatestProducts> createState() => _SliverLatestProductsState();
}

class _SliverLatestProductsState extends State<_SliverLatestProducts> {
  late Future<List<ProductsModel>> _allProducts;

  @override
  void initState() {
    super.initState();
    _allProducts = ApiHandler.of(context).getAllProducts(limit: 100);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: horizontalPadding8,
      sliver: SliverDataLoader<List<ProductsModel>>(
        loader: _allProducts,
        emptyMessage: "No products has been added yet",
        sliverBuilder: (BuildContext context, List<ProductsModel> products) {
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return FeedsWidget(product: products[index]);
              },
              childCount: products.length,
            ),
          );
        },
      ),
    );
  }
}

@immutable
class SliverRevealContent extends StatelessWidget {
  const SliverRevealContent({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollable = Scrollable.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: verticalPadding8,
        child: ClipRect(
          child: AnimatedBuilder(
            animation: scrollable.position,
            builder: (BuildContext context, Widget? child) {
              final offset = scrollable.position.hasPixels ? scrollable.position.pixels : 0.0;
              return Align(
                alignment: Alignment.topLeft,
                heightFactor: (offset / 160.0).clamp(0.0, 1.0),
                widthFactor: 1.0,
                child: child,
              );
            },
            child: const SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.red,
                      Colors.blue,
                    ],
                  ),
                ),
                child: Padding(
                  padding: allPadding8,
                  child: Text(
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing\n"
                    "Testing testing testing testing testing",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
