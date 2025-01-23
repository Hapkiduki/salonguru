import 'package:flutter/material.dart';
import 'package:salonguru/domain/entities/product.dart';
import 'package:salonguru/features/products/widgets/blur_image.dart';
import 'package:salonguru/ui/widgets/currency_text.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    required this.product,
    required this.onSelected,
    required this.onAddToCartPressed,
    super.key,
  });

  final Product product;
  final VoidCallback onSelected;
  final VoidCallback onAddToCartPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textstyle = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Hero(
                  tag: 'product_image_${product.id}',
                  child: BlurImage(
                    path: product.image,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  height: size.height * .18,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 8, top: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text(
                          product.name,
                          style: textstyle.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          product.description,
                          style: textstyle.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CurrencyText(
                              cost: product.price,
                              textStyle: textstyle.titleMedium,
                              smallextStyle: textstyle.labelMedium,
                            ),
                            IconButton.filled(
                              onPressed: onAddToCartPressed,
                              icon: const Icon(Icons.shopping_bag),
                              style: FilledButton.styleFrom(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: const Color(0xffec837d),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
