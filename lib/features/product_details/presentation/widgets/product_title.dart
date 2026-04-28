import 'package:flutter/material.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../products/domain/entities/product_entity.dart';

class ProductTitle extends StatelessWidget {
  const ProductTitle({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Text(
      product.title,
      style: AppTextStyles.titleLarge,
    );
  }
}