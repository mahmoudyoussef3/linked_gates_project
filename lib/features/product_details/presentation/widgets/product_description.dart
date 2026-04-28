import 'package:flutter/material.dart';
import '../../../../core/styles/app_text_styles.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: AppTextStyles.subtitle),
        const SizedBox(height: 6),
        Text(description, style: AppTextStyles.description),
      ],
    );
  }
}