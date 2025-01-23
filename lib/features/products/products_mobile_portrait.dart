import 'package:flutter/material.dart';
import 'package:salonguru/config/routes.dart';
import 'package:salonguru/di/shared_dependencies.dart';
import 'package:salonguru/domain/entities/cart_item.dart';
import 'package:salonguru/domain/entities/product.dart';
import 'package:salonguru/features/products/products_view_model.dart';
import 'package:salonguru/features/products/widgets/widgets.dart';
import 'package:salonguru/l10n/l10n.dart';
import 'package:salonguru/ui/widgets/beat_animation.dart';
import 'package:salonguru/ui/widgets/empty_data.dart';
import 'package:salonguru/ui/widgets/loading.dart';

class ProductsMobilePortrait extends StatefulWidget {
  const ProductsMobilePortrait({
    required this.onRefresh,
    required this.onAddToCartPressed,
    super.key,
    this.products,
    this.cartItems,
  });

  final List<Product>? products;
  final List<CartItem>? cartItems;
  final Future<void> Function() onRefresh;
  final ValueChanged<Product> onAddToCartPressed;

  @override
  State<ProductsMobilePortrait> createState() => _ProductsMobilePortraitState();
}

class _ProductsMobilePortraitState extends State<ProductsMobilePortrait> with TickerProviderStateMixin {
  final productsViewModel = sl<ProductsViewModel>();

  final Map<String, int> _cartItems = {};

  late final AnimationController _flyController;
  late final AnimationController _beatController;

  final GlobalKey _amberKey = GlobalKey();

  final Map<String, GlobalKey> _avatarKeys = {};

  @override
  void initState() {
    super.initState();

    _flyController = AnimationController(
      vsync: this,
      duration: Durations.extralong1,
    );
    _beatController = AnimationController(
      vsync: this,
      duration: Durations.extralong3,
    );
    preloadItems();
  }

  @override
  void didUpdateWidget(covariant ProductsMobilePortrait oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cartItems != widget.cartItems) {
      preloadItems();
    }
  }

  @override
  void dispose() {
    _flyController.dispose();
    _beatController.dispose();
    super.dispose();
  }

  void preloadItems() {
    final x = widget.cartItems?.asMap().map<String, int>(
          (key, value) => MapEntry(value.product.name, value.quantity),
        );
    if (x?.isNotEmpty ?? false) {
      _cartItems.addAll(x!);
    }

    setState(() {});
  }

  double get pinkHeight {
    final size = MediaQuery.sizeOf(context);
    return _cartItems.isEmpty ? size.height : size.height * 0.85;
  }

  double get amberHeight {
    final size = MediaQuery.sizeOf(context);
    return _cartItems.isEmpty ? 0 : size.height * 0.19;
  }

  double get pinkBorderRadius => _cartItems.isEmpty ? 0 : 40;

  Future<void> _onItemTap(String item, GlobalKey itemKey) async {
    final startPos = _getWidgetGlobalPosition(itemKey);
    final endPos = _getPositionInAmber(item);
    await _flyToFavorites(item: item, startPos: startPos, endPos: endPos);
    setState(() {
      _cartItems[item] = (_cartItems[item] ?? 0) + 1;
    });
    await _beatController.forward(from: 0);
  }

  Offset _getWidgetGlobalPosition(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderObject == null) return Offset.zero;
    return renderObject.localToGlobal(Offset.zero);
  }

  Offset _getPositionInAmber(String item) {
    final itemKey = _avatarKeys[item];
    if (itemKey != null) {
      final box = itemKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        return box.localToGlobal(Offset(box.size.width / 2, box.size.height / 2));
      }
    }

    final amberBox = _amberKey.currentContext?.findRenderObject() as RenderBox?;
    if (amberBox != null) {
      final pos = amberBox.localToGlobal(Offset.zero);
      return pos.translate(40, 40);
    }
    return Offset.zero;
  }

  Future<void> _flyToFavorites({
    required String item,
    required Offset startPos,
    required Offset endPos,
  }) async {
    final dx = endPos.dx - startPos.dx;
    final dy = endPos.dy - startPos.dy;

    final scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 0.7).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 80,
      ),
    ]).animate(_flyController);

    final offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(dx, dy),
    ).chain(CurveTween(curve: Curves.easeInOutCubic)).animate(_flyController);

    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (_) {
        return AnimatedBuilder(
          animation: _flyController,
          builder: (context, child) {
            final offset = offsetAnimation.value;
            final scale = scaleAnimation.value;
            return Positioned(
              left: startPos.dx + offset.dx,
              top: startPos.dy + offset.dy,
              child: Transform.scale(
                scale: scale,
                child: _buildFlyingItem(item),
              ),
            );
          },
        );
      },
    );

    overlay.insert(entry);
    _flyController.reset();
    await _flyController.forward();
    entry.remove();
  }

  Widget _buildFlyingItem(String item) {
    return Material(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      child: SizedBox(
        width: 160,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurpleAccent,
            child: Text(item.split(' ').last),
          ),
          title: Text(item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          AnimatedPositioned(
            key: _amberKey,
            duration: Durations.medium4,
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: 0,
            height: amberHeight,
            child: Hero(
              tag: 'cart-hero',
              child: BeatAnimation(
                controller: _beatController,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.blueGrey,
                  child: SafeArea(
                    child: Row(
                      spacing: 10,
                      children: [
                        FloatingActionButton(
                          heroTag: null,
                          backgroundColor: const Color(0xffec837d),
                          foregroundColor: Colors.white70,
                          child: const Icon(Icons.shopping_bag_outlined),
                          onPressed: () {
                            CartRoute().go(context);
                          },
                        ),
                        Expanded(
                          child: _buildFavoritesRow(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Durations.medium4,
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            top: 0,
            height: pinkHeight,
            child: Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.yellow[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(pinkBorderRadius),
                  bottomRight: Radius.circular(pinkBorderRadius),
                ),
              ),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  final maxHeight = size.height * .22;

                  return [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: maxHeight,
                      flexibleSpace: SgAppbar(innerBoxIsScrolled: innerBoxIsScrolled),
                    ),
                  ];
                },
                body: switch (widget.products) {
                  null => const Center(
                      child: Loading(),
                    ),
                  [...] => RefreshIndicator(
                      onRefresh: widget.onRefresh,
                      child: widget.products!.isEmpty
                          ? EmptyData(
                              item: l10n.productsItem,
                            )
                          : _buildMainList(),
                    ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.products!.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final product = widget.products![index];
        final itemKey = GlobalKey();

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ProductItem(
            key: itemKey,
            product: product,
            onSelected: () {
              ProductDetailRoute($extra: product).go(context);
            },
            onAddToCartPressed: () {
              widget.onAddToCartPressed.call(product);
              _onItemTap(product.name, itemKey);
            },
          ),
        );
      },
    );
  }

  Widget _buildFavoritesRow() {
    final favorites = _cartItems.entries.toList();

    return Center(
      child: ListView.builder(
        itemCount: widget.cartItems?.length ?? 0,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = widget.cartItems![index];
          return _buildFavoriteAvatar(
            item.product.image,
            item.quantity,
          );
        },
      ),
    );
  }

  Widget _buildFavoriteAvatar(String item, int count) {
    final key = _avatarKeys[item] ?? GlobalKey();
    _avatarKeys[item] = key;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      //key: key,
      child: Badge.count(
        count: count,
        isLabelVisible: count > 1,
        alignment: Alignment.topLeft,
        child: BlurImage(
          path: item,
          sizePercent: .07,
          key: key,
        ),
      ),
    );
  }
}
