import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';
import '../../../../core/widgets/app_message_view.dart';
import '../provider/product_provider.dart';
import '../widgets/product_item.dart';
import '../widgets/product_shimmer.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 600
                      ? 3
                      : 2;
              switch (provider.status) {
                case ProductStatus.initial:
                case ProductStatus.loading:
                  return ProductShimmerList(crossAxisCount: crossAxisCount);
                case ProductStatus.error:
                  return AppMessageView(
                    message:
                        provider.errorMessage ?? 'Failed to load products.',
                    icon: Icons.error_outline,
                  );
                case ProductStatus.success:
                  final products = provider.products;
                  if (products.isEmpty) {
                    return const AppMessageView(
                      message: 'No products found.',
                      icon: Icons.inventory_2_outlined,
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.all(16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Selector<ProductProvider, _ProductCardState>(
                        selector: (_, provider) => _ProductCardState(
                          isFavorite: provider.isFavorite(product.id),
                          priceText: provider.getFormattedPrice(product),
                        ),
                        builder: (context, state, _) {
                          return ProductItem(
                            product: product,
                            index: index,
                            isFavorite: state.isFavorite,
                            priceText: state.priceText,
                            onFavoriteTap: () {
                              context
                                  .read<ProductProvider>()
                                  .toggleFavorite(product.id);
                            },
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.productDetails,
                                arguments: ProductDetailsArgs(
                                  product: product,
                                  provider: context.read<ProductProvider>(),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
              }
            },
          );
        },
      ),
    );
  }
}

class _ProductCardState {
  const _ProductCardState({
    required this.isFavorite,
    required this.priceText,
  });

  final bool isFavorite;
  final String priceText;
}
