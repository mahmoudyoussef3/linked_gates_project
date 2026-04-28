import 'package:flutter/material.dart';
import 'package:linked_gates_project/features/product_details/presentation/widgets/product_details_widgets.dart';
import '../../../../core/styles/app_text_styles.dart';

class ProductPriceQuantity extends StatelessWidget {
  const ProductPriceQuantity({
    super.key,
    required this.priceText,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  final String priceText;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback? onDecrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(priceText, style: AppTextStyles.priceLarge),
        const SizedBox(width: 8),
        const Text('per item'),
        const Spacer(),
        InlineQuantityCounter(
          quantity: quantity,
          onIncrease: onIncrease,
          onDecrease: onDecrease,
        ),
      ],
    );
  }
}
