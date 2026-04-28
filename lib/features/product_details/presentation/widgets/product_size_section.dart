import 'package:flutter/material.dart';
import 'package:linked_gates_project/features/product_details/presentation/widgets/product_details_widgets.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../products/presentation/provider/product_provider.dart';

class ProductSizeSection extends StatelessWidget {
  const ProductSizeSection({
    super.key,
    required this.productId,
    required this.selectedSize,
    required this.provider,
  });

  final int productId;
  final dynamic selectedSize;
  final ProductProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Size', style: AppTextStyles.subtitle),
        const SizedBox(height: 10),
        ProductSizeSelector(
          selectedSize: selectedSize,
          onSelected: (size) =>
              provider.setSelectedSize(productId, size),
        ),
      ],
    );
  }
}