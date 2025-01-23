import 'package:commandy/commandy.dart';
import 'package:flutter/material.dart';
import 'package:salonguru/di/shared_dependencies.dart';
import 'package:salonguru/domain/entities/product.dart';
import 'package:salonguru/features/products/detail/product_detail_view_model.dart';
import 'package:salonguru/features/products/detail/widgets/counter.dart';
import 'package:salonguru/features/products/widgets/blur_image.dart';
import 'package:salonguru/l10n/l10n.dart';
import 'package:salonguru/ui/widgets/alert.dart';
import 'package:salonguru/ui/widgets/brand_icon_button.dart';
import 'package:salonguru/ui/widgets/currency_text.dart';
import 'package:salonguru/ui/widgets/loading.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({required this.product, super.key});
  final Product product;

  @override
  State<ProductDetail> createState() => ProductdDetailState();
}

class ProductdDetailState extends State<ProductDetail> {
  final viewModel = ProductDetailViewModel(addToCardUseCase: sl());

  @override
  void initState() {
    super.initState();
    viewModel.loadProductCommand.execute(widget.product);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void processResult(Result<void>? result) {
    final l10n = context.l10n;
    final model = result?.fold(
      (_) => AlertModel(
        text: viewModel.product.name,
        title: l10n.productSuccess,
      ),
      (failure) => AlertModel(
        text: failure.message,
        title: l10n.errorAlertText,
        type: AlertType.error,
      ),
    );
    if (result != null) {
      Alert.show(
        context,
        model: model!,
        onClose: () {
          Future.delayed(
            Durations.medium1,
            () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return CommandListener(
      listeners: [
        CommandListenerConfig(
          command: viewModel.addToCardCommand,
          listener: (context, result) {
            processResult(result);
          },
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              width: size.width,
              height: size.height,
              color: Colors.brown.withValues(alpha: .2),
            ),
            Container(
              width: size.width,
              height: size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
            ),
            Container(
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: size.height * .15),
                    Center(
                      child: Hero(
                        tag: 'product_image_${widget.product.id}',
                        child: BlurImage(
                          path: widget.product.image,
                          sizePercent: .30,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * .05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: textTheme.headlineSmall?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                            text: l10n.stock,
                            children: [
                              TextSpan(
                                text: widget.product.quantity.toString(),
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ViewModelSelector(
                          viewModel: viewModel,
                          selector: (vm) => vm.quantity,
                          builder: (context, quantity) => Counter(
                            quantity: quantity,
                            onTapped: viewModel.increaseCommand.execute,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * .03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.product.name,
                                style: textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffec837d),
                          ),
                          padding: const EdgeInsets.all(9),
                          child: CurrencyText(
                            cost: widget.product.price,
                            smallextStyle: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                            textStyle: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * .05),
                    Text(
                      widget.product.description,
                      style: textTheme.bodyLarge,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: size.height * .05,
              right: size.width * .07,
              child: BrandIconButton(
                onPressed: () {
                  viewModel.addToCardCommand.execute(const NoParams());
                },
                icon: Icons.shopping_bag,
              ),
            ),
            Positioned(
              top: size.height * .05,
              left: size.width * .07,
              child: BrandIconButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            ValueListenableBuilder(
              valueListenable: viewModel.addToCardCommand.isExecuting,
              builder: (context, isLoading, child) =>
                  isLoading ? const Center(child: Loading()) : const SizedBox.shrink(),
            ),
          ],
        ),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: viewModel.addToCardCommand.isExecuting,
          builder: (context, isLoading, child) => FloatingActionButton.extended(
            backgroundColor: isLoading ? Colors.blueGrey : const Color(0xffec837d),
            foregroundColor: Colors.white,
            elevation: 0,
            onPressed: isLoading
                ? null
                : () {
                    viewModel.addToCardCommand.execute(const NoParams());
                  },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Center(
              child: Text(
                l10n.addToCartButton,
                style: const TextStyle(
                  fontSize: 18,
                  letterSpacing: 1.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
