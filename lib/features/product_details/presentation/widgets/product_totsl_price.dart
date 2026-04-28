import 'package:flutter/material.dart';
import '../../../../core/styles/app_text_styles.dart';

class ProductTotalPrice extends StatelessWidget {
  const ProductTotalPrice({super.key, required this.totalPrice});

  final String totalPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Total', style: AppTextStyles.subtitle),
        const Spacer(),
        Text(totalPrice, style: AppTextStyles.priceLarge),
      ],
    );
  }
}