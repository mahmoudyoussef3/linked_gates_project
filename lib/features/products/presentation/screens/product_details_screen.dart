import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../provider/product_provider.dart';
import '../widgets/product_details_widgets.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductEntity product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(
      begin: 1,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateButton() async {
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => _handleBack(context),
        ),
      ),
      body: Consumer2<ProductProvider, CartProvider>(
        builder: (context, provider, cart, _) {
          final priceText = provider.getFormattedPrice(widget.product);
          final description = provider.getDescription(widget.product);
          final quantity = provider.getQuantity(widget.product.id);
          final totalPrice = provider.getFormattedTotalPrice(widget.product);
          final selectedSize = provider.getSelectedSize(widget.product.id);

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'product_${widget.product.id}',
                  child: AspectRatio(
                    aspectRatio: 1.1,
                    child: AppNetworkImage(
                      url: widget.product.imageUrl,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(widget.product.title, style: AppTextStyles.titleLarge),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(priceText, style: AppTextStyles.priceLarge),
                    SizedBox(width: 8.w),
                    Text('per item', style: AppTextStyles.caption),
                    const Spacer(),
                    InlineQuantityCounter(
                      quantity: quantity,
                      onDecrease: quantity > 1
                          ? () => provider.decrementQuantity(widget.product.id)
                          : null,
                      onIncrease: () =>
                          provider.incrementQuantity(widget.product.id),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                const SectionDivider(),
                SizedBox(height: 12.h),
                Text('Select Size', style: AppTextStyles.subtitle),
                SizedBox(height: 10.h),
                ProductSizeSelector(
                  selectedSize: selectedSize,
                  onSelected: (size) =>
                      provider.setSelectedSize(widget.product.id, size),
                ),
                SizedBox(height: 20.h),
                const SectionDivider(),
                SizedBox(height: 12.h),
                Text('Description', style: AppTextStyles.subtitle),
                SizedBox(height: 6.h),
                Text(description, style: AppTextStyles.description),
                SizedBox(height: 20.h),
                const SectionDivider(),
                SizedBox(height: 12.h),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text('Total', style: AppTextStyles.subtitle),
                    const Spacer(),
                    Text(totalPrice, style: AppTextStyles.priceLarge),
                  ],
                ),
                SizedBox(height: 16.h),
                ScaleTransition(
                  scale: _scale,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _animateButton();
                        if (!mounted) return;
                        cart.addItem(
                          product: widget.product,
                          price: provider.getDisplayPrice(widget.product),
                          size: selectedSize,
                          quantity: quantity,
                        );
                        showProductDetailsCartSnackBar(this.context);
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.products);
  }
}
