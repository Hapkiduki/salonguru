import 'dart:async';

import 'package:commandy/commandy.dart';
import 'package:flutter/material.dart';
import 'package:salonguru/config/routes.dart';
import 'package:salonguru/di/shared_dependencies.dart';
import 'package:salonguru/domain/entities/cart_item.dart';
import 'package:salonguru/domain/entities/product.dart';
import 'package:salonguru/features/features.dart';
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
  List<CartItem> _cartItems = <CartItem>[];
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
    _cartItems = widget.cartItems ?? [];
    if (_cartItems.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          _beatController.forward();
        },
      );
    }
  }

  @override
  void didUpdateWidget(covariant ProductsMobilePortrait oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cartItems != widget.cartItems) {
      _cartItems = widget.cartItems ?? [];
      _avatarKeys.clear();
    }
  }

  @override
  void dispose() {
    _flyController.dispose();
    _beatController.dispose();
    super.dispose();
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

  Future<void> _onItemTap(Product product, GlobalKey itemKey) async {
    final startPos = _getWidgetGlobalPosition(itemKey);
    final endPos = _getPositionInAmber(product.id.toString());
    await _flyToCart(item: product.image, startPos: startPos, endPos: endPos);
    widget.onAddToCartPressed.call(product);

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

  Future<void> _flyToCart({
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

  Widget _buildFlyingItem(String path) {
    return BlurImage(
      path: path,
      sizePercent: .1,
    );
  }

  Future<void> _goToCart() async {
    await CartRoute().push<void>(context);
    unawaited(sl<ProductsViewModel>().loadCartItemsCommand.execute(const NoParams()));
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
                          onPressed: _goToCart,
                        ),
                        Expanded(
                          child: _buildCartItemsRow(),
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
        final itemKey = GlobalObjectKey('item_${product.id}');

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ProductItem(
            key: itemKey,
            product: product,
            onSelected: () {
              goToDetails(product);
            },
            onAddToCartPressed: () {
              _onItemTap(product, itemKey);
            },
          ),
        );
      },
    );
  }

  Future<void> goToDetails(Product product) async {
    await ProductDetailRoute($extra: product).push<void>(context);
    unawaited(sl<ProductsViewModel>().loadCartItemsCommand.execute(const NoParams()));
  }

  Widget _buildCartItemsRow() {
    return Center(
      child: ListView.builder(
        itemCount: _cartItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = _cartItems[index];

          return _buildCartItemAvatar(
            item.product,
            item.quantity,
          );
        },
      ),
    );
  }

  Widget _buildCartItemAvatar(Product item, int count) {
    final id = item.id.toString();
    final key = _avatarKeys[id] ?? GlobalKey();
    _avatarKeys[id] = key;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      key: key,
      child: Badge.count(
        backgroundColor: Colors.redAccent,
        count: count,
        isLabelVisible: count > 1,
        alignment: Alignment.topLeft,
        child: BlurImage(
          path: item.image,
          sizePercent: .07,
        ),
      ),
    );
  }
}
